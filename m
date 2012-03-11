From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 0/4] cgroup quota
Date: Sun, 11 Mar 2012 18:50:09 +0800
Message-ID: <4F5C8361.5070303@oracle.com>
References: <4F59E78A.7060903@oracle.com> <4F5C8A0C.8050904@parallels.com>
Reply-To: jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5C8A0C.8050904-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, Christopher Jones <christopher.jones-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>, tytso-DPNOqEs/LNQ@public.gmane.org, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hi Glauber,

On 03/11/2012 07:18 PM, Glauber Costa wrote:

> On 03/09/2012 03:20 PM, Jeff Liu wrote:
>> Hello,
>>
>> Disk quota feature has been asked at LXC list from time to time.
>> Given that the project quota has already implemented in XFS for a long
>> time, and it was also in progress for EXT4.
>> So the major idea is to assign one or more project IDs(or tree ID?) to
>> container, but leaving quota setup via cgroup
>> config files, so all the tasks running at container could have project
>> quota constraints applied.
>>
>> I'd like to post an initial patch sets here, the stupid implements is
>> very simple and even crash me
>> in some cases, sorry! But I would like to submit it to get more
>> feedback to make sure I am going down
>> the right road. :)
>>
>> Let me introduce it now.
>>
>> 1. Setup project quota on XFS(enabled pquota) firstly.
>> For example, the "project100" is configured on "/xfs/quota_test"
>> directory.
>>
>> $ cat /etc/projects
>> 100:/xfs/quota_test
>>
>> $ cat /etc/projid
>> project100:100
>>
>> $ sudo xfs_quota -x -c 'report -p'
>> Project quota on /xfs (/dev/sda7)
>>                                 Blocks
>> Project ID       Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> project100          0          0          0     00 [--------]
>>
>> 2. Mount cgroup on /cgroup.
>> cgroup on /cgroup type cgroup (rw)
>>
>> After that, there will have a couple of quota.XXXX files presented at
>> /cgroup.
>> $ ls -l /cgroup/quota.*
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.activate
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.add_project
>> -r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.all
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.block_limit_in_bytes
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.deactivate
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.inode_limit
>> -r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.projects
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.remove_project
>> --w------- 1 root root 0 Mar  9 18:27
>> /cgroup/quota.reset_block_limit_in_bytes
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.reset_inode_limit
>>
>> 3. To assign a project ID to container, just echo it to
>> quota.add_project as:
>> echo "project100:100">  /cgroup/quota.add_project
>>
>> To get a short list of the current projects assigned to container,
>> user can check quota.projects,
>> # cat /cgroup/quota.projects
>> Project ID (project100:100)    status: off
>>
>> The totally quota info can be check against quota.all, it will show
>> something like below:
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: off
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    9223372036854775807
>>    inode_hard_limit    9223372036854775807
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> Note that about "status: off", by default, a new assigned project will
>> in OFF state, user could
>> turn it on by echo the project ID to quota.activate as below:
>> # echo 100>  /cgroup/quota.activate
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: on     *now  status changed.*
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    9223372036854775807
>>    inode_hard_limit    9223372036854775807
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> But it will do nothing since without quota setup.
>>
>> 4. To configure quota via cgroup, user need to interact with
>> quota.inode_limit and quota.block_limit_in_bytes.
>> For now, I only add a simple inode quota check to XFS, it looks
>> something like below:
>>
>> # echo "100 2:4">>  /cgroup/quota.inode_limit
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: on
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    2
>>    inode_hard_limit    4
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> # for ((i=0; i<  6; i++)); do touch xfs/quota_test/test.$i; done
>>
>> Project ID (project100:100)    status: on
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    2
>>    inode_hard_limit    4
>>    inode_max_usage    4
>>    inode_usage    4
>>
>> Sorry again, above steps crashed me sometimes for now, it works just
>> for demo purpose. :)
>>
>> Any criticism and suggestions are welcome!
> 
> I have mixed feelings about this. The feature is obviously welcome, but
> I am not sure if
> the approach you took is the best one... I'll go through the patches
> now, and hopefully will
> have a better opinion by the end =)

Thanks for your response!

Daniel has pointed me that Anqin had gave a try for implementing
container quota feature in UID/GUID form back to 2009, his patch set can
be found at:
https://lkml.org/lkml/2009/2/23/35

However, He had to give up because of a new job.

Looks a possible approach is to combine cgroup with project quota(or
tree quota?) according to the feedback from Paul at that time:
https://lkml.org/lkml/2009/2/23/35

So I wrote this draft patch out to present my basic ideas(even not
consider xattr storage space for XFS in current demo).

I am definitely a newbie in this area, so please forgive me if I make
some stupid mistakes. :)

Thanks,
-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs

