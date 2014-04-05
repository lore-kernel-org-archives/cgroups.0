From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Date: Fri, 4 Apr 2014 18:11:47 -0700
Message-ID: <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=4IKDYm5SCCOkoAwakUSork1PRz/WCxVXB+JzqWfYhME=;
        b=KY68f48uWfqR7zTJiQTy/5xxf6lwf+VB3cgae3GqjEI9fM/+lvxYTkPc8RJpRbU2+Q
         h3FTSFZHhcjETL90vJzZBF2Ez/760kLBrV5smqibRIy6/3ngqATYUicDPKZUckk/oxg+
         YLd53taWMGT32Dj8W5fccCLX8OzpONATly5FcJX/lxTF7xoCRfvkPPlJr45rFi5gD3xQ
         F3t+z/+f3QGo+kL/u/1TB+IperNKFavFTnoI5YD3bfrjdDzZ6l7jG5sMWYpUW8/UOjKo
         ohJ7Fp1c/2GKdQQR2i3wl6iljAmp9pHc07BrQ2mnZrZG3fLS1AFn5e9uG0Kmn/WggPGj
         XWPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=4IKDYm5SCCOkoAwakUSork1PRz/WCxVXB+JzqWfYhME=;
        b=Q1GQurmWMHs+c1qoZxDvSKBDj0sVuQNWuX6/qLcBfc22ENZrzhYMQc9ICoTjQLHTbI
         r8IJxH3P2Pn8I0AFea7m8bJ/d3hsCayWHETX7SfMdvjzbyvXQVPdlmsWkRlK2+tO2uem
         jK5Me9D5bNdoXhaRUhc0ZTwpEFFsaopdJNSx4=
In-Reply-To: <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 4, 2014 at 6:06 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> Will report back soon when I've narrowed it down more.

Ok, that may end up being harder than it looked. Commit
a755180bab81c038a6989d7ab746c702f1b3ec03 doesn't boot for me at all,
so apparently there are some really broken points in that whole
development chain.

I'll try to pick kernels away from that, but that makes bisection much
less effective.

                Linus
