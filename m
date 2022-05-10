From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 2/9] cgroup: bpf: flush bpf stats on rstat
 flush
Date: Tue, 10 May 2022 08:45:47 -1000
Message-ID: <Ynqy20FjoCIqHZ1M@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QcmVbQMJdfUcOk6mFPVNXkZt9bGV2i5Pf6lVs2tBzVA=;
        b=bqoGmmeD2eU6J99z/Cgc1jne4RgQpPHqrHsn7nRf2qGdxNoZDNh+phWWtcjNahz+vS
         2wzLLe0k7L5MgwOmXV4u8/e8bmA8y+KMxpTTK99CMER/yylrAfLNCrqM9pBf4i8UPd7F
         x01rnWDdO+g2G5i63rBkpou6zn2e8F2IVVB5UC2Jw0+9aTu1xi5qjBcJ3hsflIlrPT7D
         Fr1W3f5vuXq3n3FeAS3U9rxOJGPOC01ANdO9TUcgKDyYhKd+50y7a7itYHn4PBVJVHuC
         VJlXsJyHAWPwf/exDBl0ViOp0cw4dcXe1tEtFWNk1LNpx6jxtPpqSnV/GN0vySoL0GbS
         QV9Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 10, 2022 at 12:18:00AM +0000, Yosry Ahmed wrote:
> When a cgroup is popped from the rstat updated tree, subsystems rstat
> flushers are run through the css_rstat_flush() callback. Also run bpf
> flushers for all subsystems that have at least one bpf rstat flusher
> attached, and are enabled for this cgroup.
> 
> A list of subsystems that have attached rstat flushers is maintained to
> avoid looping through all subsystems for all cpus for every cgroup that
> is being popped from the updated tree. Since we introduce a lock here to
> protect this list, also use it to protect rstat_flushers lists inside
> each subsystem (since they both need to locked together anyway), and get
> read of the locks in struct cgroup_subsys_bpf.
> 
> rstat flushers are run for any enabled subsystem that has flushers
> attached, even if it does not subscribe to css flushing through
> css_rstat_flush(). This gives flexibility for bpf programs to collect
> stats for any subsystem, regardless of the implementation changes in the
> kernel.

Yeah, again, the fact that these things are associated with a speicfic
subsystem feels a bit jarring to me. Let's get that resolved first.

Thanks.

-- 
tejun
