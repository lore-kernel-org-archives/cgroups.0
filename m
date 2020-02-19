From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 16:33:35 -0500
Message-ID: <20200219213335.GE54486@cmpxchg.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219113139.ee60838bc7eb35747eb330fa@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JVkD5nxiTD0qf2+tDsHsfNYWqcQb37JvAO77tIsuHko=;
        b=KHQvflBumvT9ocn+DUGF92g5qIEYXn4RpN+sBAiiGI7qDTLMDNvmMXdzmPx07tdVC5
         Z0jvJ9KvD3Oz7dzhrCjSoFhzzkkoRZ5cfSGee6fXlC4SGMn+qcgJb69EApxW+QV0Ithg
         yFxee/9aU7GZEi96Gqkjtz9aGbnDEFfrQR2RtxW3VYOlLw45JSNOGyp0Qo2KHPO4KTEF
         fO+TS/HO2EgULbw5hfQWr8Ui6ZzSceXUwwZI2AQcNjv8OJCCdE9TwIsToHxrKor4ndV+
         a4UIjjq/mOCYYiNdlRbZawGhrrSJpjoQsKrEzSmsPSJkWMOrGT7A5yXMxtog1VXEBgr6
         GCOQ==
Content-Disposition: inline
In-Reply-To: <20200219113139.ee60838bc7eb35747eb330fa@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Feb 19, 2020 at 11:31:39AM -0800, Andrew Morton wrote:
> But what was the nature of these stalls?  If they were "stuck in D
> state waiting for something" then that's throttling.  If they were
> "unexpected bursts of in-kernel CPU activity" then I see a better case.

It was both.

However, the workload was able to perform with no direct reclaim
activity and no stalls, while memory.high semantics were never
violated. This means that allocation rate was not outstripping reclaim
rate, just that both of these things happened in bursts and sputters.

If the workload isn't exceeding the memory.high grace buffer, it seems
unnecessary to make it wait behind a reclaim invocation that gets
delayed on IO but will succeed before the workload comes back for the
next allocation. We can just let it get on with its thing, actually
work with the memory it just obtained, while background reclaim will
free pages as they become reclaimable. This is a win-win situation.
