From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -V7 03/14] hugetlbfs: add an inline helper for finding
 hstate index
Date: Wed, 30 May 2012 18:05:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205301805360.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=19bXRiYwAbqw/Ys7DLmeB7aMVq3w8OXRGSUBQPsqjAo=;
        b=j2VmQ9gSEdl8UZ6bkVw3R9NxO9EqoD9i5ARarFHzZlr7zqkUIrwje8hMrvY6sYW6sZ
         HPeRkATo7TPHQRWP1Q5fb2tFZNJQWRt2PLsuTnDQpAMyKArcQ2R20ioTZbfkkR7578Te
         8NJAibWKX5TvBLzo55B8IsB3LRoW+TSBtYTRM4EHKIbDHiNTG+nRL3V4ey0XTLluHlq/
         yQG7hJ2eEwPdY4doIKVWgB24CTSb2VyrHv3c0SjFcSQKkGCUQqHnFm3ewz4b37AOMm7t
         Du8vLKE+VzSpi8A7FyHbE1awoBfwS1AZReUU3UtvJdAJ+h9fIkUDFMwzf8HpB4Ir64Ls
         +J9w==
In-Reply-To: <1338388739-22919-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>

On Wed, 30 May 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Add an inline helper and use it in the code.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Hillf Danton <dhillf@gmail.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
