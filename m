From: Gang Li <ligang.bdlg@bytedance.com>
Subject: Re: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 11:22:16 +0800
Message-ID: <e444e0ca-a2ff-37f2-1f1a-032b9fd63235@bytedance.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680751340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/21m2yLLPaau0hZnScyLMJt/iOdOd36gr8LwaGmrjkk=;
        b=UjR6qAdKwCf4JhGnnVtmV2pwm9se7kPWAMUPhZaCbtyZcvuE1N0flcKyd2uBFVOTrC
         WwUmb+zrcZnE4bFbhZG2UisTWrzQme6k9pof7bg7D6BwGYiqkgPN4nSVoPX+OVY1CkoV
         qa/rMmt+0D1YyngYNb8nXkzLNXcGB0OfhevUXIGVkUjEXR4lDwck4hwmJMR/zC16UCEZ
         hoO/1pd8TX2QwEmwnJBAMHyo1APThW4JcmR3CBw/z+d6dLeoQX48Pz+NAa0Afrsy/2W7
         9g7AJm+3XEnGF7c/m3VzAZSl7tOKMehPK9QpcPGTguEZFcfPB/ylmTNK2bws009RpgoZ
         uCsg==
Content-Language: en-US
In-Reply-To: <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: rientjes@google.com, linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org


On 2023/4/4 22:31, Michal Hocko wrote:
> [CC cpuset people]
> 
> The oom report should be explicit about this being CPUSET specific oom
> handling so unexpected behavior could be nailed down to this change so I
Yes, the oom message looks like this:

```
[   65.470256] 
oom-kill:constraint=CONSTRAINT_CPUSET,nodemask=(null),cpuset=test,mems_allowed=0,global_oom,task_memcg=/user.slice/user-0.slice/session-4.scope,task=memkiller,pid=1968,uid=0
Apr  4 09:08:53 debian kernel: [   65.481992] Out of memory: Killed 
process 1968 (memkiller) total-vm:2099436kB, anon-rss:1971712kB, 
file-rss:1024kB, shmem-rss:0kB, UID:0 pgtables:3904kB oom_score_adj:0
```


> do not see a major concern from the oom POV. Nevertheless it would be
> still good to consider whether this should be an opt-in behavior. I
> personally do not see a major problem because most cpuset deployments I
> have seen tend to be well partitioned so the new behavior makes more
> sense.
> 

Since memcgroup oom is mandatory, cpuset oom should preferably be 
mandatory as well. But we can still consider adding an option to user.

How about introduce `/proc/sys/vm/oom_in_cpuset`?
