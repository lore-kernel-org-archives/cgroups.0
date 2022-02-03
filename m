From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 4/4] mm/page_owner: Record task command name
Date: Thu, 3 Feb 2022 13:10:43 +0100
Message-ID: <91fb8637-6550-dc37-a95b-df7812b02b0a@suse.cz>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220131220328.622162-1-longman@redhat.com>
 <YflRjeoC0jbzArDG@dhcp22.suse.cz>
 <4ba66abe-5c6d-26a7-f11c-c3b8514bfb34@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643890244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=osIhrdtOjjmkFFphcb83Nczt+7vGIRa7d6OObVoINEs=;
        b=VhapAhebHkYqVU+ErQEcL6KulK37k5BjSG1CLIDdCh/yTExSO04ZuZymV71zPilFsdgOfA
        wF2ZIVe+bnEC36RO81mRv65injO9CyFWPGm8vITJPbRh2wAkyrrqLKGNBjicMVuBQXTMT+
        eB52FxaQGUmLUFtnHKdRV5Tx2v81Fyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643890244;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=osIhrdtOjjmkFFphcb83Nczt+7vGIRa7d6OObVoINEs=;
        b=nnKKymePe6Gbn1kwuKkf/SJxV5DxbzCLpIFF/YkxH57g/HA2GqJLuip3Rn+iSZxEe0CZM6
        Tqir+aIs1KACZyDA==
Content-Language: en-US
In-Reply-To: <4ba66abe-5c6d-26a7-f11c-c3b8514bfb34-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/2/22 17:53, Waiman Long wrote:
> 
> On 2/1/22 10:28, Michal Hocko wrote:
>> Cc Vlastimil
>>
>> On Mon 31-01-22 17:03:28, Waiman Long wrote:
>>> The page_owner information currently includes the pid of the calling
>>> task. That is useful as long as the task is still running. Otherwise,
>>> the number is meaningless. To have more information about the allocating
>>> tasks that had exited by the time the page_owner information is
>>> retrieved, we need to store the command name of the task.
>>>
>>> Add a new comm field into page_owner structure to store the command name
>>> and display it when the page_owner information is retrieved.
>> I completely agree that pid is effectivelly useless (if not misleading)
>> but is comm really telling all that much to compensate for the
>> additional storage required for _each_ page in the system?
> 
> Yes, it does add an extra 16 bytes per page overhead. The command name can
> be useful if one want to find out which userspace command is responsible for
> a problematic page allocation. Maybe we can remove pid from page_owner to
> save 8 bytes as you also agree that this number is not that useful.

Pid could be used to correlate command instances (not perfectly if reuse
happens), but command name could have a higher chance to be useful. In my
experience the most useful were the stacktraces and gfp/order etc. anyway.
So I wouldn't be opposed replacing pid with comm. The mild size increase
should be acceptable, this is an opt-in feature for debugging sessions with
known tradeoff for memory and cpu overhead for the extra info.

> Cheers,
> Longman
> 

