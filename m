From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 1/3] mm, oom: move declaration for mem_cgroup_out_of_memory
 to oom.h
Date: Tue, 26 Jun 2012 02:04:32 -0400
Message-ID: <CAHGf_=q5qOudHJoXqCULkNjy_80r8_7UXQnKgYsu9sV8Kn0RPA@mail.gmail.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <4FE9289B.2050105@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        bh=u5O/QnU9/a1plY6l+68ey18IaPOfbGVOpgY6q0isnJ0=;
        b=bwyz5sN7S4iAUTrcvRxweSE5SyOoGLyBPpULmtSAuNrb/fyD/ujoNPxEUEAbVCQc9o
         W3Bd017LyDaJJXXbmbFzCabUUb7ZsnuzUzFoNiZ3hYTe4aMVY+Hz/m9VUWOPw3IzknHZ
         h8o9RmqKd+Eq1LPpiLVdvdlczZij5NJ4D5NXC++RdTLicPd+SaoTuK1fkCrBt0HZbkYc
         RYYISbcaAPCpzALP9biOZ/3ZbqO5iVVD3wLOObNs1TpSwDLo6ylOCaCgmNf6CF2G91M1
         O3oQl1TdGBcY+8cyn0mhT2yujQH8o+IqEUO9Z+NdsOsr5o1/oD2m5CqlCR3dOjTG/oxw
         aWyg==
In-Reply-To: <4FE9289B.2050105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 25, 2012 at 11:12 PM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/06/26 10:47), David Rientjes wrote:
>>
>> mem_cgroup_out_of_memory() is defined in mm/oom_kill.c, so declare it in
>> linux/oom.h rather than linux/memcontrol.h.
>>
>> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
