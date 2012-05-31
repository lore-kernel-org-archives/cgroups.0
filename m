From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -V7 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
Date: Wed, 30 May 2012 18:02:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205301801060.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=9Ip3FRGJVF+cMKbpKGTPAQr50YkIioRViNso0575uxY=;
        b=gGG7kDJGHQApuHz4qOQInV8JS7AJAzyqnpQGjyyeUV4M2LSbxZZpRy7jJnM926v2NZ
         ap6eRNY43vG5P1MRNKNjgy+si5+0fX2bOwfZ/o9SdCHs51HUxYVeZgTh7pjzo6L3NqFC
         WJaWeozJIa3JvQHxjQdNE5FpTGwIFGXUAUEq57a/iVTsAuZN6jxVd2P0Kbcbfe3d3kLV
         H3UN4Xsi0C2lAVHmyiqJ884tdlAlX52zxe4LykwTt87nDbWreHcm2dhS2SYFEnCkeImr
         ZLc+lCyswop9HkioqjnO/VDoNnNP6Fc1EPBcCGoGl3dZQ41wFKOW/s73RE5vBzwYRoVU
         KtJA==
In-Reply-To: <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>

On Wed, 30 May 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value.  Decouple the
> VM_FAULT_* values from MAX_ERRNO.
> 

Yeah, but is there a reason for using VM_FAULT_HWPOISON_LARGE_MASK since 
that's the only VM_FAULT_* value that is greater than MAX_ERRNO?  The rest 
of your patch set doesn't require this, so I think this change should just 
be dropped.  (And PTR_ERR() still returns long, this wasn't fixed from my 
original review.)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
