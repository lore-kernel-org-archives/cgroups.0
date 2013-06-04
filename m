From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v4] Soft limit rework
Date: Tue, 4 Jun 2013 23:27:05 +0530
Message-ID: <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
	<CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
	<20130604163828.GA9321@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=sgzGekkzeXMLtE1nyafYKMBjNBMcolPJi54WYkSeNl0=;
        b=ZLI9eM9ViM1DmvIDQGG1dRptVddBDZpTa2gR9wy7nk15mvwE6ZhejFY2jLd2AFBjpe
         YRvWNlmmJSdeXkuOFAFBOvGR+G5ZVpSPyUcUhdePFUiTk+6sEiQ2qmZbpcocCvbGJ+D/
         u9eJQDcpHIqeO0UhhbtNq32j1rjYshtRu9192qN2gF56/hrtXW1GGS5yjdDzQPg/2Ki7
         ZhdB/Bgar5fhkRX2LbbsI/E77KJIQ0SWU0J+1VeT+o9A6pMnNTk23Z0WlqhKPtwfPk1X
         Apshd+XKLsuCDvyq2zPvHErNq45MXyPXSnbyOEs+RwnEvw5NapMu2yuW6OkHM7Kq7c9F
         hpyg==
In-Reply-To: <20130604163828.GA9321@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>

> OK, let me summarize. The primary intention is to get rid of the current
> soft reclaim infrastructure which basically bypasses the standard
> reclaim and tight it directly into shrink_zone code. This also means
> that the soft reclaim doesn't reclaim at priority 0 and that it is
> active also for the targeted (aka limit) reclaim.
>
> Does this help?
>

Yes. What are the limitations of no-priority 0 reclaim? I'll also look
at the patches

Thanks,
Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
