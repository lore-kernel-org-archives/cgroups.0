From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Documentation: cgroup-v2.rst: Correct number of stats
 entries
Date: Thu, 3 Aug 2023 14:12:38 -1000
Message-ID: <ZMxCdojf1-SFQWaN@slm.duckdns.org>
References: <tencent_D28A72FC6B13C2955D8CD3200E939DA78D08@qq.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691107961; x=1691712761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mK/SUGZd/Inm2gGsrCEsgPACkbFKLFUt6mW7c1W89dY=;
        b=DtSGG/oRMwGU3wuk4qrV+2+UcwBZ77mVPn2F8Ts7bZHxnr3d+2Ip7akJrrmqJ92uoJ
         W5f7xrDRhSIlCMdVoEPDSJLWESCedoCAR3GQAMLTyLPgYlRFs+yuJpd+RPgT9yTr6hKz
         fqZF/D/AfJU1Zf5KwLPUe2HS6WtArMSPi5NTlAHAZAEpMQP5d7Q6aDfxqLibxpeP7S8e
         6mQttf6nQbMBJtJSHVaQX9uhseiyr3V7mcepWY9wCIU4S4+/41B9gvDZbGg7lUW8nAnM
         ZpLLRPLTNMWzeJpHnXs3N/Qo8Cqu04PEFsjRNA7skCwtcwNJHpGWKSpB6xkPkCnRM0TK
         KzAQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <tencent_D28A72FC6B13C2955D8CD3200E939DA78D08-9uewiaClKEY@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Han Dapeng <han-dapeng-9uewiaClKEY@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Han Dapeng <han-dapeng-H32Fclmsjq1BDgjK7y7TUQ@public.gmane.org>

On Thu, Aug 03, 2023 at 11:55:27PM +0800, Han Dapeng wrote:
> From: Han Dapeng <han-dapeng-H32Fclmsjq1BDgjK7y7TUQ@public.gmane.org>
> 
> Signed-off-by: Han Dapeng <han-dapeng-H32Fclmsjq1BDgjK7y7TUQ@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
