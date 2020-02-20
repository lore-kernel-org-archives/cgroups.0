From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 9/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 docs
Date: Wed, 19 Feb 2020 16:18:47 -0800
Message-ID: <5f57d4c2-8bf2-e544-a7ba-efb8fe64a25a@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-9-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QWEL2irsvo55ZuVX9rYS+HXpqn01G2Z2MKSCHVrtka0=;
 b=h+lPWXRDgcy4sltXvrrlq8TtBRRSGu1GpX2n8kLYsVaj23Kj2NTvbXVhIcN/t70jst+9
 kF28bH7om4O7uLeBN2un5zoRztPAWsuOF/V0BJavu2kqNnJKfFlaSu/aV3xKDy7VRnir
 tLDY+Q2jKzLPwdSJpMGdEpJQCKxPs1lma9evBRE+YEatgLTQbNZYyjAisVNyMO2/Ec/W
 FUa8piTrGfjGvcNnsJBwWbiHbOn2FSxVjmJMNU7wu5RJG+DMuc40SK1MV7pUz/NO09Ng
 i6OECB/9lwTQxut22NGK+6i0BJdcFG7dNCSxvg/roTyLV3uKJBlvqjI4SZozllsVyaTG uA== 
In-Reply-To: <20200211213128.73302-9-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> Add docs for how to use hugetlb_cgroup reservations, and their behavior.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks for updating the documentation.

Acked-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Mike Kravetz
