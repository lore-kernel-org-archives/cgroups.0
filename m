From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Date: Wed, 7 Sep 2022 05:43:31 -1000
Message-ID: <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=P2y+BRPoGQxcqMhj3bfHoCPdDwxzhdrBdUaNfcmh0tE=;
        b=f5sV92bQm4uCzJmJSVchg7K5WurYb/bA7u1+zpo2OohtxddaHLFxpVSinPu25hGluS
         VkVOWz86PqadpIhvGnfZmfe930SnCERVZ2J3AOA0m1LyyfcQEry8dCLvK5fhH9KSEV18
         /rRmvEwReN/H0EpByLp1q/20tf9gmD9mgGGF6nSZdvU47MkCXJlk8293pdZBJKCefA5y
         YYWhiBYlY8h7ehdLbUBnhi1pc7HuYKW1myQIGQxATR/Q0Szx3n2srUQgWD96HzkCvz1Y
         LymO1eHKTcsuqUITTxAhGw24ZQ/KfJpsIFl0lx9Je8dNu3aJcnroCfGUMot1FAOcAwyP
         nK9Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220902023003.47124-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
...
> This patchset tries to resolve the above two issues by introducing a
> selectable memcg to limit the bpf memory. Currently we only allow to
> select its ancestor to avoid breaking the memcg hierarchy further. 
> Possible use cases of the selectable memcg as follows,

As discussed in the following thread, there are clear downsides to an
interface which requires the users to specify the cgroups directly.

 https://lkml.kernel.org/r/YwNold0GMOappUxc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org

So, I don't really think this is an interface we wanna go for. I was hoping
to hear more from memcg folks in the above thread. Maybe ping them in that
thread and continue there?

Thanks.

-- 
tejun
