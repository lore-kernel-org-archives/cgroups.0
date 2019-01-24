From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: Move maxable seq_file logic into a single place
Date: Thu, 24 Jan 2019 14:25:52 -0500
Message-ID: <20190124192552.GA27084@chrisdown.name>
References: <20190124061718.GA15486@chrisdown.name>
 <20190124160935.GB12436@cmpxchg.org>
 <20190124165634.GA13549@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ghgBouyMlgr0hppUprLH+laQ2Q5C3qhKtj/1pgdB4Pk=;
        b=kXE5I3qaDTEG+JhQtUbG3LO27nMj4ayuUHaSuiitGKn3SJt8rI8Wq+4L/hlYG7wUAP
         jz1785z219Sj/gJwtJ6K3IzdfFYvYsu6E5xDUHLKCmAsuVPhNvX7FLE8amdVA5xh20Zu
         HN0fa/uED5Jtig1m8f5GPnKQ6jFmyewcoOTNU=
Content-Disposition: inline
In-Reply-To: <20190124165634.GA13549@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

I'm going to abandon this patch in favour of a patch series which does it 
without macros, but still reduces code duplication fairly significantly. I'll 
send it out shortly.
