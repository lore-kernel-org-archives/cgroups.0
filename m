From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
Date: Tue, 22 Apr 2014 18:17:09 +0800
Message-ID: <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com> <20140422094759.GC29311@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=D08OKhC9wgnhOv7XGKlwNTMWKiyKIevczrW2xPP5/Zg=;
        b=IACl9pwKiZsntTzliPm9uaU7+nUCfEbVuG9O3syduJqx8DGxkUz+YYd5H3VoiJg17t
         bh5KYvmgIcN5eekt4H7mnhwzzybdhM0P6YMQ0zDf0IC3/2IT2WSj+303WQrueEhXfdgS
         yVHJJmGSY4WzA52lYBDeQxRJ7z6oQU7ZrlzThWKP2Zaeu5eticwy9FOGqd9WSwmZJnIb
         RLb8IOm1iAwtjuX+A3u2izxSSNmUcWyUoEjnJ32MXw4eggwpRpxXgr85Q16YYunZCzYY
         G2q9n7rq3HDdFOnBQ3Wjopljr8QBw3bU96RPavbCiCaetOG6Yjmk/CglOO5D6cJAv1b1
         CU7g==
In-Reply-To: <20140422094759.GC29311@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Apr 22, 2014 at 5:47 PM, Michal Hocko <mhocko@suse.cz> wrote:
> What about
>   3. last_visited == last_node in the tree
>
> __mem_cgroup_iter_next returns NULL and the iterator would return
> without visiting anything.

Hi,  Michal,

yep,  if 3 last_visited == last_node, then this means we have done a round-trip,
thus __mem_cgroup_iter_next returns NULL, in turn mem_cgroup_iter() return NULL.

This is what comments above mem_cgroup_iter() says:

>Returns references to children of the hierarchy below @root, or
>* @root itself, or %NULL after a full round-trip.

Actually, this condition could be reduced to conditon 2.1

Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
