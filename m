From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bruno.premont-KvovOCrn0kWDPSPedkhhuQ@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Fri, 10 Apr 2020 10:43:43 +0200
Message-ID: <20200410104343.5bcde519@hemera.lan.sysophe.eu>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
        <20200409094615.GE18386@dhcp22.suse.cz>
        <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
        <20200409103400.GF18386@dhcp22.suse.cz>
        <20200409170926.182354c3@hemera.lan.sysophe.eu>
        <20200409152540.GP18386@dhcp22.suse.cz>
        <20200410091525.287062fa@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200410091525.287062fa-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

Hi Michal, Chris,

Well, tar made me unhappy, it just collected list of files but not
content from /sys/fs/cgroup/...

But if I set memory.max = memory.high reclaim seems to work and memory
pressure remains zero for the cg.
If I set memory.max = $((memory.high + 128M)) memory pressure rises
immediately (when memory.current ~= memory.high).

Returning to memory.max=memory.high gets things running again and
memory pressure starts dropping immediately.


Could it be that the wrong limit of high/max is being used for reclaim?


Bruno

On Fri, 10 Apr 2020 09:15:25 +0200
Bruno Prémont <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org> wrote:
> Hi Michal,
> 
> On Thu, 9 Apr 2020 17:25:40 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Your earlier stat snapshot doesn't indicate a big problem with the
> > reclaim though:
> > 
> > memory.stat:pgscan 47519855
> > memory.stat:pgsteal 44933838
> > 
> > This tells the overall reclaim effectiveness was 94%. Could you try to
> > gather snapshots with a 1s granularity starting before your run your
> > backup to see how those numbers evolve? Ideally with timestamps to
> > compare with the actual stall information.  
> 
> Attached is a long collection of
>  date  memory.current   memory.stat[pgscan]  memory.stat[pgsteal]
> 
> It started while backup was running +/- smoothly with its memory.high
> set to 4294967296 (4G instead of 2G) until backup finished around 20:22.
> 
> From system memory pressure RRD-graph I see pressure (around 60)
> between about 19:50 to 20:10 while very small the rest of the time
> (below 1).
> 
> 
> 
> I started a new backup run this morning grabbing full info snapshots of
> backup cgroup at 1s interval in order to get a better/more complete
> picture and CG's memory.high back to 2G limit.
> 
> 
> I have the impression as if reclaim was somehow triggered not enough or
> not strongly enough compared to the IO performed within the CG
> (complete backup covers 130G of data, data being read in blocks of
> 128kB at a smooth-running rate of ~7MiB/s).
> 
> > Another option would be to enable vmscan tracepoints but let's try with
> > stats first.  
> 
> 
> Bruno



-- 
Bruno Prémont <bruno.premont-KvovOCrn0kWDPSPedkhhuQ@public.gmane.org>
Ingénieur système et développements

Fondation RESTENA
2, avenue de l'Université
L-4365 Esch/Alzette

Tél: (+352) 424409
Fax: (+352) 422473
https://www.restena.lu     https://www.dns.lu
