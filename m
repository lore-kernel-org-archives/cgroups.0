From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How cpu entitlement is calculated/enforce for cpu subgroup?
Date: Mon, 15 Sep 2014 10:22:34 +0530
Message-ID: <CAKTCnzn_ojuS8LD-6V32dv5_wnxg5=Tp4sb0Usa-qFi34MxvEw@mail.gmail.com>
References: <08a001cfd07f$2219bd90$664d38b0$@gmail.com>
	<541652F5.5010604@gmail.com>
	<CAKTCnzkVx7_aeTrYKQCBXoSj2w4z-cMSqOEYJRkLVAEGz_bdrA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ln74EnypsYLf7ToW6ztLxQmjR+G/ONL44cDJM/Zskps=;
        b=zm/0rOD74tod1RNVkgiec7jOD9K0aY7FQfJb5/6dNFdHamGYVeEoHbP6Rsmi5kp+6W
         JgZ6V27BVnN0Mdm16vZOXtknsUMnEW80aRZES37vKP0q+k6ak231f2OxuYnjQewMZwKb
         4IIbDqgnudIs1OuWLUb3HgAJ9krqZEyomM3OnBBRfltZE3kla45uxRPvz3b357cg6BMQ
         Wivbs1rVEDvApZIvSAlfoq05k/Nk6Mrf3kBnk3xKfCXg1/pEUGrz2T85HPyNoU+BOfbK
         eQ2q0UPs+EmICsBSFP6k8HBXW8N5Ex8hK5yrhjdvPaoeYDncBh2TOUwnRsmQnHPQH7IK
         qocQ==
In-Reply-To: <CAKTCnzkVx7_aeTrYKQCBXoSj2w4z-cMSqOEYJRkLVAEGz_bdrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: james <wjn740-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: John Wei <johntwei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML-cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Use weights to understand how it works. A/A1/A2 can be written as

      A
A1      A2

50% of A for A1 and A2 and 50% for the task in A. A itself receives
50% of the CPU. So the task in A gets 25% and the remaining A1 and A2
get 12.5% each (add up to 25%)

Ideally you should see a distribution of 12.5, 12. 5 and 25, but due
to round up and short term monitoring, you might see 10, 10, 30
