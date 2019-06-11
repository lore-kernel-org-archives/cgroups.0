From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 05/33] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Date: Tue, 11 Jun 2019 12:03:32 -0700
Message-ID: <20190611190332.GI3341036@devbig004.ftw2.facebook.com>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
 <79865a4248ce5b042106e5ec69bb493292a8d392.1560045490.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TINH5Zv9sdfI5yGkKfukd7zEs5gc5SFmFE6Rm33jogw=;
        b=sTbvzg1IBs2bb8cjreY5cBasSaH+2pFI5pjQ35wagL+18kPnXLznCC9TyL/tH+M4hP
         q8EzAGJHmuFs3cTKR1D9zefrPRRKJAU8/AOrhIRoejq49CWhnsGswe/IoyW+3pLcVrZA
         idoBHD6D/SGQjCHVkxMcAuSa0qZ0UYf6PuryCCl6KxGiUpZO9zLoZB/vD1r7/EDrA+xH
         AVkmXuIzCTP0+FrXVOmES1ohd6KLAjLFxCArXYNa/4QqLSZCec9i31IIvqj3lneR3rck
         uR0BMYPVVBv3BGDTkrSUVMI/X2O/9KCPcGFl11pf9di+5Ug8qf/qOIO7Nn2RveaTofno
         9dig==
Content-Disposition: inline
In-Reply-To: <79865a4248ce5b042106e5ec69bb493292a8d392.1560045490.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-security-modu

On Sat, Jun 08, 2019 at 11:26:55PM -0300, Mauro Carvalho Chehab wrote:
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

Please feel free to route with the rest of the series.  If you want
the patch to be routed through the cgroup tree, please let me know.

Thanks.

-- 
tejun
