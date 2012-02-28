From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 08/10] memcg: Add CONFIG_CGROUP_MEM_RES_CTLR_KMEM_ACCT_ROOT.
Date: Tue, 28 Feb 2012 15:36:27 -0800
Message-ID: <CABCjUKAUQZuW9hFeMJ1Oh=0UeS2Ffx4-vHpnaGpjOFu+3KktAA@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-9-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD7E7.1070901@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=Lsbvo5wTm50iW51D2jOb6CPcsnMqk7p697JAlqKavos=;
        b=i0kwdh73tevBZNRk47esbzPyfOJ8wZR6kOodTYiB7rXhSUCveo+3InyeU6aX0kham5
         05+jtFqYMNYNuT8ijylXIFjR0WjR0NQFdoXfctZkUmvJKTx+Em5XJjlFt7A33bK3OKUk
         318LSKcqV3hu9xEJj+f8+TxWVmXQg3/9rC7B7fodS+uZZ8hfweZckITgxXgykgMwgCG+
         0poF+Eb6ZRAGjDiA9+1kJ1bww2MC+ShcwSt+gKF11WXXIviWNMl4Ncni7wxvHMakSXoT
         7GioQiR5hQhWv2YNE8mea36jzGPsI0XGBQD6YhqVrH1eLOgQppg1BByy1SHORBfpvV3K
         ANcg==
In-Reply-To: <4F4CD7E7.1070901@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, yinghan@google.com, hughd@google.com, gthelen@google.com, linux-mm@kvack.org, devel@openvz.org

On Tue, Feb 28, 2012 at 5:34 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
>>
>> This config option dictates whether or not kernel memory in the
>> root cgroup should be accounted.
>>
>> This may be useful in an environment where everything is supposed to be
>> in a cgroup and accounted for. Large amounts of kernel memory in the
>> root cgroup would indicate problems with memory isolation or accounting.
>
>
> I don't like accounting this stuff to the root memory cgroup. This causes
> overhead for everybody, including people who couldn't care less about memcg.
>
> If it were up to me, we would simply not account it, and end of story.
>
> However, if this is terribly important for you, I think you need to at
> least make it possible to enable it at runtime, and default it to disabled.

Yes, that is why I made it a config option. If the config option is
disabled, that memory does not get accounted at all.

Making it configurable at runtime is not ideal, because we would
prefer slab memory that was allocated before cgroups are created to
still be counted toward root.

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
