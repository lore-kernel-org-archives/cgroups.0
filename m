From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] oom: rework dump_tasks to optimize memcg-oom situation
Date: Thu, 08 Nov 2012 21:58:52 +0800
Message-ID: <509BBA9C.7050007@gmail.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277719-21760-1-git-send-email-handai.szj@taobao.com> <20121107223437.GC26382@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=UguCFhAsL3Vjc3lrI4VK4LbuC5L6yrIWIGb4jSI3BEY=;
        b=MApKHgYksUmRlK7ni83pqlYgp699U1UouXrPq+VQPqdki+UeolrI+0zhhWF7vFWWWd
         N3A8Rps3h9bNf3OQxZK93DK+Qas94Wf7U0dVjxs9P+4WwYxlWJcsOj2c65sZvR3jZFJf
         cAqECIuT1auZQW91ZL9zm2uDGpkkPyY8sYA3xmNKqyUaFsnnXRekE0ZfC9nXxezIx95t
         7IMi48Pmldu+rnEQ0AXQk/sm01etTUnpAvq4lykcDVYQrdZ1VACbr7fsxDSt+mxjC03I
         vBp+KuF0OZ9AzaDRZo7+HQe4dsCv0C5AZ/hZoH9rl3biSYIRUoCQ+xeTUvSjRX+kiB1i
         oGOw==
In-Reply-To: <20121107223437.GC26382-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 11/08/2012 06:34 AM, Michal Hocko wrote:
> On Wed 07-11-12 16:41:59, Sha Zhengju wrote:
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> If memcg oom happening, don't scan all system tasks to dump memory state of
>> eligible tasks, instead we iterates only over the process attached to the oom
>> memcg and avoid the rcu lock.
> you have replaced rcu lock by css_set_lock which is, well, heavier than
> rcu. Besides that the patch is not correct because you have excluded
> all tasks that are from subgroups because you iterate only through the
> top level one.
> I am not sure the whole optimization would be a win even if implemented
> correctly. Well, we scan through more tasks currently and most of them
> are not relevant but then you would need to exclude task_in_mem_cgroup
> from oom_unkillable_task and that would be more code churn than the
> win.

Thanks for your and David's advice.
This piece is trying to save some expense while dumping memcg tasks, but 
failed to
scanning subgroups by iterating the cgroup. I'm agreed with your cost&win
opinion, so I decide to give up this one. : )


Thanks,
Sha
