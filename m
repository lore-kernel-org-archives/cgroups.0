From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Thu, 20 Sep 2012 11:26:51 -0700
Message-ID: <20120920182651.GH28934@google.com>
References: <20120913205827.GO7677@google.com>
 <505A725B.2080901@amacapital.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5fZe8zjM4hmvxBJATpAUvSRBtZtlDidywBPCvyUjObo=;
        b=MBB8LgVZxhnx8OftIGoM/wRBgEYlNTua9p7ZpYQtwl6aIBhaO/EYt7evLgtFcTskx7
         abQ1h6YmkNBFB8vURNeLewntwqsJJMNMBJoOsLqlFOgigeCD1YbBdicDi648UCVHoCe+
         jb3GSelOQotQ2jBxDYLv6nsf6Q2KWUUqDo7OgiJEqX6GnHQ3zxdDAoV8PzS88C3Rk7ES
         vjzn/DoH38pZCefOAOWkjoaZLF9tRICviA9GlWTUNTIFBXt4eiXUybcaF9LoZdxMg8Kf
         c4s35ugPUtns9wEKid5pJoqYmRPLl3CZGvJovG+etQxHL3wKGa93NKoN0XxgHxsD+7tX
         RV2Q==
Content-Disposition: inline
In-Reply-To: <505A725B.2080901-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4RrovVCs/uTlw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org

Hello,

On Wed, Sep 19, 2012 at 06:33:15PM -0700, Andy Lutomirski wrote:
> [grr.  why does gmane scramble addresses?]

You can append /raw to the message url and see the raw mssage.

  http://article.gmane.org/gmane.linux.kernel.containers/23802/raw

> >   I think this level of flexibility should be enough for most use
> >   cases.  If someone disagrees, please voice your objections now.
> 
> OK, I'll bite.
> 
> I have a server that has a whole bunch of cores.  A small fraction of
> those cores are general purpose and run whatever they like.  The rest
> are tightly controlled.
> 
> For simplicity, we have two cpusets that we use.  The root allows all
> cpus.  The other one only allows the general purpose cpus.  We shove
> everything into the general-purpose-only cpuset, and then we move
> special stuff back to root.  (We also shove some kernel threads into a
> non-root cpuset using the 'cset' tool.)

Using root for special stuff probably isn't a good idea and moving
bound kthreads into !root cgroups is already disallowed.

> Enter systemd, which wants a hierarchy corresponding to services.  If we
> were to use it, we might end up violating its hierarchy.
> 
> Alternatively, if we started using memcg, then we might have some tasks
> to have more restrictive memory usage but less restrictive cpu usage.
> 
> As long as we can still pull this off, I'm happy.

IIUC, you basically want just two groups w/ cpuset and use it for
loose cpu ioslation for high priority jobs.  Structure-wise, I don't
think it's gonna be a problem although using root for special stuff
would need to change.

Thanks.

-- 
tejun
