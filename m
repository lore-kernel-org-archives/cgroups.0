From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: simplify code in cgroup_apply_control
Date: Fri, 23 Sep 2022 16:52:37 -1000
Message-ID: <Yy5w9YFfmZX+9Vq+@slm.duckdns.org>
References: <20220917084039.3177-1-williamsukatube@163.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=P8vaI21b92NWGEjpnCZy/ODfb54d6FrqhksNG5cepIM=;
        b=caLduk/X8w4TnrVwSePAZCEH+FzRhkWjC4M0DPcbbDsa5BILOuhtNcXGd8A3oh66UR
         lriiKxLvcTpSIy3D7eh0T2sQzbH3DgktH3gfWckNZn+hkFuNO2zPI6iqQlh0P/h5R0yU
         R7Ahpl/xjHazmSLed2t/OvNlLchNTmnymyQuuy5N3EMhG0dJ7tbCkosPH5/jrMuAVSbU
         doGSVQjEm/Pe1RlEFPg2mZYTAwosPvOW3KPWLP7JY66NdTuGuAQPjap4ie2VbxhmW+N1
         EX9y7Ha/HGTltUUoM6yrSCxi8vNKpcT84nl6N/oVoMSIVhdYdB9VupgIZ5F6W2ZX5dby
         IW4g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220917084039.3177-1-williamsukatube-9Onoh4P/yGk@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: williamsukatube-9Onoh4P/yGk@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Sep 17, 2022 at 04:40:39PM +0800, williamsukatube-9Onoh4P/yGk@public.gmane.org wrote:
> From: William Dean <williamsukatube-9Onoh4P/yGk@public.gmane.org>
> 
> It could directly return 'cgroup_update_dfl_csses' to simplify code.
> 
> Signed-off-by: William Dean <williamsukatube-9Onoh4P/yGk@public.gmane.org>

Applied to cgroup/for-6.1.

Thanks.

-- 
tejun
