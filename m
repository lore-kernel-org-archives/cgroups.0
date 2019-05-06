From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 08/79] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Date: Mon, 6 May 2019 08:47:25 -0700
Message-ID: <20190506154725.GS374014@devbig004.ftw2.facebook.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <c6e79690c038fc6bbf9265a065c1f861d6e156fa.1555938375.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E/XjEjFJHTNXNUvCeIBTVGrT6CD0tFJQfkjcnYeMhDY=;
        b=WFo86atePse5UmQK+FdjsQtdOQVjO6JrWLd1xYEi2IMozqnr1cQ3J6vuxd3K5gctkU
         XsHuazRLDKDlGNx+rMgrPMRCPJ6oBDmOOlutFuDcLwMPw4scj7kpqzMv7cl6hg35vWEY
         5Jo6jnIk5CH1m9lNzIXjTixLiTU77ECI7aUU/JbALWp0cMUgMEwkMgZ7hD3uN9i6ImhW
         2a3f1jij5WKh6ZVyp1ZYKiNoBS3PgNo3b11OoMZftLmzMwIrn3ULeWrJwifkleo4h6d6
         bKGMiQvOOvCNzRjOGOOP6O5nxYth83P/miVp9QGwck0+wEWuGrwwA1wlrLAfhekoHQTn
         pYyg==
Content-Disposition: inline
In-Reply-To: <c6e79690c038fc6bbf9265a065c1f861d6e156fa.1555938375.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-security-modu

On Mon, Apr 22, 2019 at 10:26:57AM -0300, Mauro Carvalho Chehab wrote:
> Convert the cgroup-v1 files to ReST format, in order to
> allow a later addition to the admin-guide.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with other patches in the series.

Thanks.

-- 
tejun
