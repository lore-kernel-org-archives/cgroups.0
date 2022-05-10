From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 08:44:23 -1000
Message-ID: <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PY+WJJsqIbfDwJgzkuBE2iPkWgMrw4K1Mhhpa4dAqtU=;
        b=p00MbnRqdRmjeePF8YWO/lHYe4mcUBFcKUfEBVak/KvHMu0ou5wk4CPtT/oCkXaR48
         KuOCnGuz8Tupkgg8erPU71pw/B9OfUdw27Ms83guk1NRhCXBQvolY998RoMWgk/u1H9W
         sE08oN8p86ys70WKR7PmsfQ9mJvfWyZfkM6eGPX2N0k1g1THUfJg3JXUrt+TD3H4wDJo
         y7zo6tzKoehDCXIHdWGAoDhj1aUs5r7fLWEEmubl89AFL6lyXcE/qmTCmsvn5fiYsZSz
         UCgu32eq2rKygSnX8KRwTTLTj8MYrGsNZ54/Zu3xSvdorA3bhe4kssveKBF1bAx+dqsy
         pHxw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Tue, May 10, 2022 at 12:17:59AM +0000, Yosry Ahmed wrote:
> @@ -706,6 +707,9 @@ struct cgroup_subsys {
>  	 * specifies the mask of subsystems that this one depends on.
>  	 */
>  	unsigned int depends_on;
> +
> +	/* used to store bpf programs.*/
> +	struct cgroup_subsys_bpf bpf;
>  };

Care to elaborate on rationales around associating this with a specific
cgroup_subsys rather than letting it walk cgroups and access whatever csses
as needed? I don't think it's a wrong approach or anything but I can think
of plenty of things that would be interesting without being associated with
a specific subsystem - even all the cpu usage statistics are built to in the
cgroup core and given how e.g. systemd uses cgroup to organize the
applications in the system whether resource control is active or not, there
are a lot of info one can gather about those without being associated with a
specific subsystem.

Thanks.

-- 
tejun
