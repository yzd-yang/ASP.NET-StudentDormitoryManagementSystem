<%@ Page Language="C#" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        Random rand = new Random();
        char[] code = new char[4];
        for (int i = 0; i < 4; i++)
        {
            code[i] = chars[rand.Next(chars.Length)];
        }
        string checkCode = new string(code);
        Session["CheckCode"] = checkCode;

        int width = 100;
        int height = 40;
        using (Bitmap bitmap = new Bitmap(width, height))
        {
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.Clear(Color.FromArgb(245, 255, 220));

                for (int i = 0; i < 4; i++)
                {
                    int x1 = rand.Next(width);
                    int y1 = rand.Next(height);
                    int x2 = rand.Next(width);
                    int y2 = rand.Next(height);
                    g.DrawLine(new Pen(Color.FromArgb(73, 234, 206), 1), x1, y1, x2, y2);
                }

                for (int i = 0; i < 30; i++)
                {
                    int x = rand.Next(width);
                    int y = rand.Next(height);
                    bitmap.SetPixel(x, y, Color.FromArgb(73, 234, 206));
                }

                using (Font font = new Font("Arial", 18, FontStyle.Bold | FontStyle.Italic))
                {
                    using (StringFormat sf = new StringFormat())
                    {
                        sf.Alignment = StringAlignment.Center;
                        sf.LineAlignment = StringAlignment.Center;
                        g.DrawString(checkCode, font, new SolidBrush(Color.FromArgb(0, 64, 56)), new RectangleF(0, 0, width, height), sf);
                    }
                }
            }

            Response.ContentType = "image/gif";
            bitmap.Save(Response.OutputStream, ImageFormat.Gif);
        }
    }
</script>