From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] clone.2: Document CLONE_INTO_CGROUP
Date: Fri, 15 May 2020 13:41:46 +0200
Message-ID: <CAKgNAkhXxWFE8msNkJ3117ChacWsfiMsBptZsVJOnxGtuDTX0Q@mail.gmail.com>
References: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g@mail.gmail.com>
 <20200410104132.294639-1-christian@brauner.io> <b7550fcd-ba12-e64a-3228-e6668b31a8a7@gmail.com>
 <CAKgNAkhQr+sKGAu+KcxPEsuwG3kjQOyzVW7E1yM9cMtSZrhW9A@mail.gmail.com> <20200423101420.udkmlhnfg57lsshi@wittgenstein>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=RWK3xRBK3vF039IvGRjdVtIEkl1uwsII0GmOE8enEhg=;
        b=AQ9HX6rwWWp133kyVs2PIJL5t+b/npGe7W2nKwSP00VnDRcm0saijkshcdRXR10VlL
         N3QvsCS9Nf+I1JhMOMiw+s9X5sS4vLhmyuKy3L+93WpWfow7gI05+dOZYGAI5r4cU8y1
         rJx1+S0EECUThKB3RqnhXEQreTT8itZR/odWs96CLWvXaxSos2ymicfJwUvXxUq2Cyaf
         KnRBdDXaLTKwoY3NlxhBOVeOCPlpn00Mf7t+vRbun0vUbFkFWOI+2VVcglalTkwpQD0C
         ktLCP3/1ggat4CkA0bkiK1Ciph/UfOrPoEWagk2/a3RWjWai3Tb1ecqCvmVFj90S59jX
         vAPQ==
In-Reply-To: <20200423101420.udkmlhnfg57lsshi@wittgenstein>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello Christian,

Ping!

Thanks,

Michael

On Thu, 23 Apr 2020 at 12:14, Christian Brauner
<christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Apr 21, 2020 at 04:30:46PM +0200, Michael Kerrisk (man-pages) wrote:
> > Hi Christian,
> >
> > Ping!
>
> Will likely take a few days until I can get around to prepare a second
> version. Sorry for the delay!
>
> Christian



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
