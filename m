From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 05/28] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Date: Fri, 14 Jun 2019 13:30:33 -0700
Message-ID: <20190614203033.GD657710@devbig004.ftw2.facebook.com>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
 <c1dd623359f44f05863456b8bceba0d8f3e42f38.1560361364.git.mchehab+samsung@kernel.org>
 <20190614141401.48bfb266@lwn.net>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AurvGG5md8kdmEphcGq2SiHYTXdU1Fp3TGMe3JSDOo0=;
        b=ponl8/TKF4625A5i4nwix1bf/BKuWpdnWdsbj1AYGUJeoO6YwVASh4cXNfVx9IvaZa
         CFwxikzqVVjimctDR05UE41qDDK4m4UYGGq6lT/dI8Ixp9oxQCdYqc2Z3XtJrBBoXrBq
         umOejNZ+ajnJrFU8/luWxLTc7Lm3AgFpFjiX5f8hfTa03/nmo8RpqMAR3V/rc21lr+pO
         P0+G+E4MVXjXkkNwPVaW1x6EO7L4vXqTBB1608iq6Bbm2erdxjqToEzmht7mQ7XHe7Ki
         LsXMlWNkp0G6rLPcPPR+KhweE4x8FfhIUl4x1cZTqJy/9LML7BZbbD8ApalUlsrWEJMI
         TxRg==
Content-Disposition: inline
In-Reply-To: <20190614141401.48bfb266@lwn.net>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, l

On Fri, Jun 14, 2019 at 02:14:01PM -0600, Jonathan Corbet wrote:
> On Wed, 12 Jun 2019 14:52:41 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > Convert the cgroup-v1 files to ReST format, in order to
> > allow a later addition to the admin-guide.
> > 
> > The conversion is actually:
> >   - add blank lines and identation in order to identify paragraphs;
> >   - fix tables markups;
> >   - add some lists markups;
> >   - mark literal blocks;
> >   - adjust title markups.
> > 
> > At its new index.rst, let's add a :orphan: while this is not linked to
> > the main index.rst file, in order to avoid build warnings.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> This one, too, has linux-next stuff that keeps it from applying to
> docs-next.  Tejun, would you like to carry it on top of your work?

Applied to cgroup/for-5.3.

Thanks.

-- 
tejun
