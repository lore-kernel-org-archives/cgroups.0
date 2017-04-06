From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 1/4] mm: memcontrol: clean up memory.events counting
 function
Date: Thu, 6 Apr 2017 11:31:32 +0300
Message-ID: <20170406083132.GA2268@esperanza>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qjw9Ube7yi89eD+1oN1wvMARYGdmGRFOXBBYMgLw5LI=;
        b=eRs1TJeCaFDOoc+ndrcsYMfETLY2KwuEHwvbcWS7mpNdX66VhYHk+Q16GoY30E9C+d
         EaNnvIzGqZJLq+or27EY9r6QiExhC3KZ+8ZQacNBlYmN3G6zy2LxpSrP4QuSa8YiJTrH
         dwE2vMbz9SuqK5EiSTuv+0OGvIltDZhjrHeEj29ocwOFLhCN/l1vwU7jU8TGdg7g7IWP
         6Y5zs/82I7LLdStlarfVxXz2J4Fax3DJqIn/3rbIwkMJ7M3XAvPEmN7QOVBB7qwAWC9w
         K4YhK+kcb+Ny4g18i4j6NYEvWboE3tmyYoI2Dqp3l9qMinMdyj38Ku5pmHwSDi1eVYmV
         6TuQ==
Content-Disposition: inline
In-Reply-To: <20170404220148.28338-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Apr 04, 2017 at 06:01:45PM -0400, Johannes Weiner wrote:
> We only ever count single events, drop the @nr parameter. Rename the
> function accordingly. Remove low-information kerneldoc.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
