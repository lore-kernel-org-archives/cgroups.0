From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V2 2/3] memcg: alter mem_cgroup_{update,inc,dec}_page_stat()
 args to memcg pointer
Date: Tue, 14 May 2013 17:00:08 +0800
Message-ID: <CAFj3OHXH35ej2bQ+U1+zk6kHg4jU3LneOg=bnoJJ6jQFpTm3Gw@mail.gmail.com>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
	<1368421524-4937-1-git-send-email-handai.szj@taobao.com>
	<20130513122504.GA5246@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=+3+jXfB18OtN2wxGrDerYoytEf+iY380isHGT5X9IxI=;
        b=WvVGQD36NR/xTsc9azG1KvKOZaWW2woN8DZl2L0Cy1KBozyw8XnusD6Q6sCDZFszGy
         3HlONCA9U7lkPWFYH8r6CJKZKzlxNz7wYng5TV7SQGd7j6nx7VAEzhCy4QJeqUhNwD8c
         zihlh3KVXDKxngtQcuVsSXifFxFel/OH+uBDw0ur3TuDz9dGuPyltqdJDwQAphQMXzsA
         jpmXQUmtSFGPsu/MLoe3EX+sGsjd9vsTaKNIA213iGRm3knYSVDATT3Yyuwm+QENIo7f
         2GkK/6C7tpRIWIr0El4n08UlOS+n51LPrn88DosLr/8jfQBSA/VFJL0g9aC9mue0ITub
         aniQ==
In-Reply-To: <20130513122504.GA5246@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>, Sha Zhengju <handai.szj@taobao.com>

On Mon, May 13, 2013 at 8:25 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 13-05-13 13:05:24, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Change the first argument of mem_cgroup_{update,inc,dec}_page_stat() from
>> 'struct page *' to 'struct mem_cgroup *', and so move PageCgroupUsed(pc)
>> checking out of mem_cgroup_update_page_stat(). This is a prepare patch for
>> the following memcg page stat lock simplifying.
>
> No, please do not do this because it just spreads memcg specific code
> out of memcontrol.c. Besides that the patch is not correct.
> [...]
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1109,12 +1109,24 @@ void page_add_file_rmap(struct page *page)
>>  {
>>       bool locked;
>>       unsigned long flags;
>> +     struct page_cgroup *pc;
>> +     struct mem_cgroup *memcg = NULL;
>>
>>       mem_cgroup_begin_update_page_stat(page, &locked, &flags);
>> +     pc = lookup_page_cgroup(page);
>> +
>> +     rcu_read_lock();
>> +     memcg = pc->mem_cgroup;
>
> a) unnecessary RCU take for memcg disabled and b) worse KABOOM in that case
> as page_cgroup is NULL. We really do not want to put
> mem_cgroup_disabled() tests all over the place. The idea behind
> mem_cgroup_begin_update_page_stat was to be almost a noop for !memcg
> (and the real noop for !CONFIG_MEMCG).

It's indeed an unwise behavior. How about also wrapping it in
mm/memcontrol.c or memcontrol.h?

>
> so Nak to this approach



--
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
