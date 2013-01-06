From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 8/8] memcg: Document cgroup dirty/writeback memory statistics
Date: Sun, 6 Jan 2013 10:55:43 +0800
Message-ID: <CAFj3OHWyMoF=ykaneD-tBMoDrBfWT6VrUWQ871CHPTxU=Ce5jg@mail.gmail.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456501-14818-1-git-send-email-handai.szj@taobao.com>
	<50DCF185.7050408@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=NUxb6/dYsC+LSjfmI44ngR1pQCbgYftLLcml4eDp5fU=;
        b=NLs5u9447AVmvphweFvbPztChlN/euqmZP4N/QQYik2MPqLQfyk0P7+oNt8MuJV8Uk
         9FMSZgg0kv06lVBAU9LK8OHu2378IJ8737xWRSmzJxXRRf4FAhAp3IR8aD8KSLtDMoEF
         kAqW/t3qlOD72jU45O37OECNC9QHJLUyRFZmfFBTyH+z8m/tda1Z4TUiVko7HBoZsvkd
         Gs/MSt4XNjwXwlr45wMaghMg8oaZAfQNmMc7WDbcBOKrKRiK/5YPdBveq2jCk1aDOZC8
         AaaHr3mU7jckVUCKnYiFiOu1EF01lrTqWXyneK9KrUhzkOxxQik3xPuK+BaizgZht9G0
         IBWw==
In-Reply-To: <50DCF185.7050408-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 28, 2012 at 9:10 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/12/26 2:28), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> I don't think your words are bad but it may be better to sync with meminfo's text.
>
>> ---
>>   Documentation/cgroups/memory.txt |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
>> index addb1f1..2828164 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
>> @@ -487,6 +487,8 @@ pgpgin            - # of charging events to the memory cgroup. The charging
>>   pgpgout             - # of uncharging events to the memory cgroup. The uncharging
>>               event happens each time a page is unaccounted from the cgroup.
>>   swap                - # of bytes of swap usage
>> +dirty          - # of bytes of file cache that are not in sync with the disk copy.
>> +writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
>>   inactive_anon       - # of bytes of anonymous memory and swap cache memory on
>>               LRU list.
>>   active_anon - # of bytes of anonymous and swap cache memory on active
>>
>
> Documentation/filesystems/proc.txt
>
>        Dirty: Memory which is waiting to get written back to the disk
>    Writeback: Memory which is actively being written back to the disk
>
> even if others are not ;(
>


The words are actually revised by Fengguang before:
https://lkml.org/lkml/2012/7/7/49
It might be more accurate than previous one and I just follow his advise...


Thanks,
Sha
