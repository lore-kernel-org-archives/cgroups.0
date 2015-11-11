From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/6] slab: add SLAB_ACCOUNT flag
Date: Wed, 11 Nov 2015 11:19:04 -0500
Message-ID: <20151111161904.GE6246@mtj.duckdns.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov@virtuozzo.com>
 <20151110183808.GB13740@mtj.duckdns.org>
 <20151110185401.GW31308@esperanza>
 <20151111155450.GB6246@mtj.duckdns.org>
 <20151111160719.GX31308@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jto4sxvpBkNMjfYwzJekJkW1uxXsWNRJA9umvllUKTs=;
        b=sJue7xVmbV3cfzBXCAmgXPPqHmctvlG3Q/dT/0YTMvxhUCTGVoLIXiZUMBPVmbzSAk
         f1e8zYu6ZShORhy7ufxaUvCbF30luUcqZCWLEJVEL/vdB+5bJZC+mC4AkwMAEHH1x7so
         Cl6GfdG1yErNhDTgAxJUqv80iTIu1eCgzcSvYycXREnjXVZm21cJcIhqrPvvLUEalryr
         2psBD4n4AW5n8/g6soFjvdESXJ2pgnxXkdBO3nOmAD9L2iBM3lOOR/O8jSo2gXYB28K8
         9Rkp4xlW0xysP0CfqOVk7kWIWYxOZtg+wjdEDQBJ5mL2JcPzaHeDON25am1vkqrUVH0q
         D4aQ==
Content-Disposition: inline
In-Reply-To: <20151111160719.GX31308@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Vladimir.

On Wed, Nov 11, 2015 at 07:07:19PM +0300, Vladimir Davydov wrote:
> What about external_name allocation in __d_alloc? Is it occasional?
> Depends on the workload I guess. Can we create a separate cache for it?
> No, because its size is variable. There are other things like that, e.g.
> pipe_buffer array.

You're right.  Ah, it was so close. :(

-- 
tejun
