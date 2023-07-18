From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/misc: Change counters to be explicit 64bit
 types
Date: Tue, 18 Jul 2023 12:52:10 -1000
Message-ID: <ZLcXmvDKheCRYOjG@slm.duckdns.org>
References: <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
 <20230718010845.35197-1-haitao.huang@linux.intel.com>
 <20230718010845.35197-2-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689720732; x=1692312732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zaaIJSqrG494B+IR6XnJYhrqBHMp5GMdu1zHCLyiGYI=;
        b=TyD+VnTKX9Bn+aYMr/dB4EhK/Uv4WMA+GewMLDH1kkehkeagP5XXmyA4q1DIVNjF3w
         YxT6kyspFNoSp+guSUo2bO81uzyI0lZJ+VlptYiffxLFEgGHupE4u00n21/1oim5FOnW
         ZSX3QDpgEAcqrqRIZ7rXXuSk5MzJEPdgdYHRIhquAr2s6TAyxY0dwlzMyns6B81gKmqx
         96TGy+fOwRGp7TXa44C2xpnSvvxyoQO3I2XXNHfq5k+pkwj0FSb71OJdbiX+sdh2QNY1
         PdJtghSOsIK0thkDKiKWV9YT/pqfhdlDjqnf7acWiUWLLCBEfmoQRz6aG2O4ndwGXhY9
         kirQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230718010845.35197-2-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Mon, Jul 17, 2023 at 06:08:45PM -0700, Haitao Huang wrote:
> So the variables can account for resources of huge quantities even on
> 32-bit machines.
> 
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied to cgroup/for-6.6 with some whitespace adjustments. I think the code
is broken when we cross the signed boundary but that's not a new problem
caused by your patch. I think what we should do is to treat atomic64_t reads
as u64 instead of putting it in s64.

Thanks.

-- 
tejun
