From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/7] devcg: Added rdma resource tracker object per task
Date: Tue, 8 Sep 2015 11:24:56 +0300
Message-ID: <55EE9B58.70908@mellanox.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <1441658303-18081-5-git-send-email-pandit.parav@gmail.com>
 <55EE76C7.1000804@mellanox.com>
 <CAG53R5VwLnDUjpOwaD_gZMkRBjyT1Wg_sSPw2gAg9oJkqdn3dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5VwLnDUjpOwaD_gZMkRBjyT1Wg_sSPw2gAg9oJkqdn3dQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08/09/2015 10:04, Parav Pandit wrote:
> On Tue, Sep 8, 2015 at 11:18 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On 07/09/2015 23:38, Parav Pandit wrote:
>>> @@ -2676,7 +2686,7 @@ static inline int thread_group_empty(struct task_struct *p)
>>>   * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
>>>   * subscriptions and synchronises with wait4().  Also used in procfs.  Also
>>>   * pins the final release of task.io_context.  Also protects ->cpuset and
>>> - * ->cgroup.subsys[]. And ->vfork_done.
>>> + * ->cgroup.subsys[]. Also projtects ->vfork_done and ->rdma_res_counter.
>> s/projtects/protects/
>>>   *
>>>   * Nests both inside and outside of read_lock(&tasklist_lock).
>>>   * It must not be nested with write_lock_irq(&tasklist_lock),
>>
> 
> Hi Haggai Eran,
> Did you miss to put comments or I missed something?

Yes, I wrote "s/projtects/protects/" to tell you that you have a typo in
your comment. You should change the word "projtects" to "protects".

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
