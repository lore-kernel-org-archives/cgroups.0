From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V5] memcg, oom: provide more precise dump info while memcg
 oom happening
Date: Fri, 21 Dec 2012 11:40:52 +0800
Message-ID: <CAFj3OHXBFg=xZbvFwWwMQNipC0mCn2hS9pFH59HDmzS9YKqz4Q@mail.gmail.com>
References: <1355925061-3858-1-git-send-email-handai.szj@taobao.com>
	<alpine.DEB.2.00.1212191439530.32757@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=/6NDLJwqu9IhpD9LyWjuLdWhipOMYKE8aUZfuR/RHnc=;
        b=Xe+mtYUMu65TBcRYja1L9TkEIaluMr658f2+M+fBFp6NoDvbCHRoEK6MztdfG+kyrR
         S30ZhGFqRi0J1kVZ4cvwB5for3X7Tv94tI54Hhn9JlpTkGEBIDEJU+1jELyWZWMJyjPa
         Ej6xGiUgk7Vp7PtbTgxMque9ryL6yAmyrnkJ/Admq11TyNMBDHIF14oW05hxu+LPRx2P
         mSGgoWDHWm+lLmr38z3FMEmsBu/g4VEsrllY6f49tSRBA0Y1EtMvnq6X7FUdrVN7R/gL
         ilgoD8CRLgMx4lkYAmZOJo7aRn/kQX9/NouNb4DVuOIOFRl6tY2iRbNjlzsR//aXBIj8
         dKdw==
In-Reply-To: <alpine.DEB.2.00.1212191439530.32757@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: cgroups@vger.kernel.org, mhocko@suse.cz, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Sha Zhengju <handai.szj@taobao.com>

> I'd ask that you put a limit on the number of memcgs you print statistics
> for to prevent spamming the kernel log, otherwise it would be trivial to
> overwrite the entire buffer.  Do we really need the memory statistics forank
> the memcg 32 levels above us, for example?

Yeah, now there is no limit on numbers of printed memcg. But do we really
need to build so complicate memcg hierarchy for 32 levels? There is no
such usage now at least in our environment. : )


Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
