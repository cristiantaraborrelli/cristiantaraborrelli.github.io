"""Convert markdown bold (**...**) and italic (*...*) to Unicode Mathematical Bold/Italic.
Accented chars (à, è, é, ó, ù, ö, á, etc.) are left unchanged inside bold/italic spans."""
import re, sys, pathlib

BOLD_MAP = str.maketrans(
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    "\U0001D41A\U0001D41B\U0001D41C\U0001D41D\U0001D41E\U0001D41F\U0001D420\U0001D421\U0001D422\U0001D423\U0001D424\U0001D425\U0001D426\U0001D427\U0001D428\U0001D429\U0001D42A\U0001D42B\U0001D42C\U0001D42D\U0001D42E\U0001D42F\U0001D430\U0001D431\U0001D432\U0001D433\U0001D400\U0001D401\U0001D402\U0001D403\U0001D404\U0001D405\U0001D406\U0001D407\U0001D408\U0001D409\U0001D40A\U0001D40B\U0001D40C\U0001D40D\U0001D40E\U0001D40F\U0001D410\U0001D411\U0001D412\U0001D413\U0001D414\U0001D415\U0001D416\U0001D417\U0001D418\U0001D419\U0001D7CE\U0001D7CF\U0001D7D0\U0001D7D1\U0001D7D2\U0001D7D3\U0001D7D4\U0001D7D5\U0001D7D6\U0001D7D7"
)
ITALIC_MAP = str.maketrans(
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "\U0001D44E\U0001D44F\U0001D450\U0001D451\U0001D452\U0001D453\U0001D454ℎ\U0001D456\U0001D457\U0001D458\U0001D459\U0001D45A\U0001D45B\U0001D45C\U0001D45D\U0001D45E\U0001D45F\U0001D460\U0001D461\U0001D462\U0001D463\U0001D464\U0001D465\U0001D466\U0001D467\U0001D434\U0001D435\U0001D436\U0001D437\U0001D438\U0001D439\U0001D43A\U0001D43B\U0001D43C\U0001D43D\U0001D43E\U0001D43F\U0001D440\U0001D441\U0001D442\U0001D443\U0001D444\U0001D445\U0001D446\U0001D447\U0001D448\U0001D449\U0001D44A\U0001D44B\U0001D44C\U0001D44D"
)

def to_bold(m):
    return m.group(1).translate(BOLD_MAP)

def to_italic(m):
    return m.group(1).translate(ITALIC_MAP)

def convert(text):
    text = re.sub(r"\*\*([^*]+?)\*\*", to_bold, text)
    text = re.sub(r"(?<!\*)\*([^*\n]+?)\*(?!\*)", to_italic, text)
    return text

def instagram_count(text):
    """Instagram conta caratteri in UTF-16 code units. Mathematical Bold/Italic
    occupano 2 code units (surrogate pair). Questo è il conteggio reale che Instagram applica."""
    return len(text.encode("utf-16-le")) // 2

if __name__ == "__main__":
    src = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
    out = convert(src)
    sys.stdout.buffer.write(out.encode("utf-8"))
    sys.stderr.write(f"\n[IG count UTF-16: {instagram_count(out.strip())} / 2200]\n")
