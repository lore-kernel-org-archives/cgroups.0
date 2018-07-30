From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory, and
 IO v2
Date: Mon, 30 Jul 2018 10:54:05 -0700
Message-ID: <dfc3c810-8918-add4-b818-8b9c294f5ea4@infradead.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180727220123.GB18879@amd> <20180730154035.GC4567@cmpxchg.org>
 <20180730173940.GB881@amd>
 <20180730175120.GJ1206094@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Jijkqbke+KlulpxFU8QfzKm63i1lUXpS4B7IzqkuFCY=; b=z9KQJpFaFByINWmDqFflNs49p4
        1nzJq4A93NJbv5qHKVaT8uBW77Xr4/stgbn3xw50XHAElz0w+HWPyZT4CMHKc8BrCX92tTkWfk6oU
        tt7C8p4KUh4122DKWbKT9sYGrbMMzAa1CSK4nZrSSdd60tuano1z5NBl1nCMe/gZAm2napCVS0Tsq
        fdFC0H7ecOuglOTsBNihKm4MyH8MtRYREi71dklG708YW7rvg+tHSmYuY22MBaJcA2Pcq0A3C35hJ
        THoDwvS85M27t2I1xGjiBxH/Xl+YCcPRQB4JHEBtBXmOkDEJ1ttrMwf4VjYYZztpluI27J0twTxOX
      
In-Reply-To: <20180730175120.GJ1206094@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Pavel Machek <pavel@ucw.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 07/30/2018 10:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 30, 2018 at 07:39:40PM +0200, Pavel Machek wrote:
>>> I'd rather have the internal config symbol match the naming scheme in
>>> the code, where psi is a shorter, unique token as copmared to e.g.
>>> pressure, press, prsr, etc.
>>
>> I'd do "pressure", really. Yes, psi is shorter, but I'd say that
>> length is not really important there.
> 
> This is an extreme bikeshedding without any relevance.  You can make
> suggestions but please lay it to the rest.  There isn't any general
> consensus against the current name and you're just trying to push your
> favorite name without proper justifications after contributing nothing
> to the project.  Please stop.
> 
> Thanks.

I'd say he's trying to make something that is readable and easier to
understand for users.

Thanks.


-- 
~Randy
