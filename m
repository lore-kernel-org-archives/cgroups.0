From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in handle_mm_fault
Date: Wed, 25 Nov 2015 14:08:41 +0100
Message-ID: <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
 <20151125084403.GA24703@dhcp22.suse.cz> <565592A1.50407@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=BdQA6flHyuZqgDOiMs6RKGhaI03gQ/h5mAhS40QbeNg=;
        b=IcfpAVVxmCJCyFLGafYlGmrTA798pJsMJwpcg5cQaC8HDag29emXLSzUk52ne+u+yC
         HIz/kv+2Nf6sefz4B8vmVtwrtjesTlvBoozarymSQ6ZJk+R4XQ67V2LucCoUJ/XYrcDl
         4+ke+UaTm8nFkjElxw7kLEFkRxantOHrvazz4tr3zc+KVowPXas2CSJXMdj6n1puEmRQ
         H2mpq+Sq82nVBQ35xxG4w3gXiwXqeMKNc4UTYxXOAW6SwRxDFZmFFPTNExAVGsJDyHtX
         LF0hvyI8r8RrDwQsQ3OfRwj1bOCfuwTTWetAu2RJl1xBM262gfsOUTis2hBaVB4djwaI
         wHTg==
In-Reply-To: <565592A1.50407@I-love.SAKURA.ne.jp>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>

On Wed, Nov 25, 2015 at 11:51 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> On 2015/11/25 17:44, Michal Hocko wrote:
>> Sasha has reported the same thing some time ago
>> http://www.spinics.net/lists/cgroups/msg14075.html. Tejun had a theory
>> http://www.spinics.net/lists/cgroups/msg14078.html but we never got down
>> to the solution.
>
> Did you check assembly code?
> https://gcc.gnu.org/ml/gcc/2012-02/msg00005.html

If the race described in
http://www.spinics.net/lists/cgroups/msg14078.html does actually
happen, then there is nothing to check.
https://gcc.gnu.org/ml/gcc/2012-02/msg00005.html talks about different
memory locations, if there is store-widening involving different
memory locations, then this is a compiler bug. But the race happens on
a single memory location, in such case the code is buggy.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
