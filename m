From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -V7 01/14] hugetlb: rename max_hstate to
 hugetlb_max_hstate
Date: Wed, 30 May 2012 17:55:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205301755420.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=Oqhb4mZJBGCKSonRwCW8nNBM5TwlB7vkATXhsG+wIDk=;
        b=B0/shb5oZvLMRHq9oyWSAZtTfow4dhjE0p9CvLezhzUY/pygeev9Y/DMGmCRXYrZp8
         7NOQcV1mofQp92nfzmuf/Jf4LvBTo8ZtL4Yx2SlusRIGOMxxcRbhJUyb7N4HCshPfOFF
         tKXQNyk50XJRjJCO9bqRFfNlbgiD3WKmXRU7TC5E899sT6kjUYw4c5IrsQlA+fUuHr5r
         NzP6JucMEzXi9vAXfl1GkML/XUp28jcwNyDS4P3p+z0wfggsstVFU7mujm6nUHI0DZu9
         wS5UkdeSpHMkGZ48BLzRYrsroQjrw/ooCaDKuTbo3xl1sVD2lmpolArgT1msmn1BpxmT
         1fyQ==
In-Reply-To: <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>

On Wed, 30 May 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
> subsystems like hugetlb controller in later patches.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hillf Danton <dhillf@gmail.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
