From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v1] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Fri, 13 Aug 2021 13:36:01 +0100
Message-ID: <YRZnMYCN1ArhM3wE@chrisdown.name>
References: <1628855870-5070-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OVsoLc8GnI2MJx0koPlkzsYORog3roebBSA9S9Lp1xo=;
        b=egAI5MaCx9xeTeaDTXJ3k5cDg0ZnINbnSaS3tFWQFxO+8aN/v/SDF1W1pqnitQiAnn
         JOdHqGMJiOhw8oNbpX0AUwKa31k8vhYnX+ilDmFTLF/bGvem4ZRyEYTMMo4/Pj4Frz2U
         a7kPYvvhIUpNfKqRAtMWAjrLfm6aekJejIKng=
Content-Disposition: inline
In-Reply-To: <1628855870-5070-1-git-send-email-wang.yong12@zte.com.cn>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: yongw.pur@gmail.com
Cc: tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com, tglx@linutronix.de, peterz@infradead.org, shakeelb@google.com, guro@fb.com, alexs@kernel.org, richard.weiyang@gmail.com, sh_def@163.com, sfr@canb.auug.org.au, wang.yong12@zte.com.cn, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, yang.yang29@zte.com.cn

yongw.pur@gmail.com writes:
>From: wangyong <wang.yong12@zte.com.cn>
>Inspired by PSI features, vmpressure inotifier function should also be
>configured to decide whether it is used, because it is an independent
>feature which notifies the user of memory pressure.
>
>Since the vmpressure interface is used in kernel common code, for
>users who do not use the vmpressure function, there will be
>additional overhead.

Could you please demonstrate this additional overhead with profiles or 
demonstrations of other real world effects? Thanks.
