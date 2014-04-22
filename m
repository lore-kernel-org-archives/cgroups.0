From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
Date: Tue, 22 Apr 2014 19:53:50 +0800
Message-ID: <CAHz2CGXETcRq3cBDvkPm8JKcRA4qkhJefxz_VsmMouqfsGN5SA@mail.gmail.com>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz> <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
 <20140422103420.GI29311@dhcp22.suse.cz> <CAHz2CGUZyv-dvUUoSi2Vk_vgPAMqRN4yEg4F4XsKQ8udHeo2bQ@mail.gmail.com>
 <20140422114838.GK29311@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=uUrcKPlou+mHoxBudiWN6OS6ApnMVyE2VuUnHmh1094=;
        b=e+XR1Rs3CUP2t+abwJs07Ql1cwKodrw3Nr+riqkIDiV1T0V0xK6oN+f3wtQdwKT+J2
         3HdvsQzZ/DaWXfLdAhEh9uwQyBk5lByMDrreHqFY22BOQDMtQV2JOwHJ7iIWkSQj6aBr
         1m21zpGlgY/eXGE9dh1OpJXyeIxy+E6gN1y8DH2o6c3wTrgXox9vOnnfO2VyIrzEOt2E
         ipHkZw6/cDqaLi5Zf4rHWoyJWkovwPojLBpg1SrNw0J7Ku/QfKDJBEHJm6KmHYGjIjIQ
         aKPsDFVIOAcH5LZj64Ikjpu76p+U17IplLm+pD1zGPTArgkrQEaVSloAs0/9yFPT8oez
         BZXA==
In-Reply-To: <20140422114838.GK29311@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Apr 22, 2014 at 7:48 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Dunno, this particular case is more explicit but it is also uglier so I
> do not think this is an overall improvement. I would rather keep the
> current state unless the change either simplifies the generated code
> or it is much better to read.

hmm, I agree.  I will give it more thinking.

Seem this has been merged into -mm.  Andrew, please drop it!

Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
