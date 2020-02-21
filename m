From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Thu, 20 Feb 2020 16:52:16 -0800
Message-ID: <bfb05dfa-4b01-df19-9698-777cae2e78d2@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-8-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2MiF4dVUkc3MWcos/LfkCVZBhlj/IhF6lAwfrxFDkGk=;
 b=Qa/xiybLHd9cEcexFOZ9pJSEyObVBONrKnMXTPyepXmHtEcZ0bI8S2QysIO7RX225It1
 GV6xK+t8Os/XZwfWhTLbjC6Y4kkhaGDG/WWkfcGy4Prfan1HaRuVt2b0kdQmLopqCsmM
 jpTBHsFVTPUPxXj2f7xrUhrV2qCPNQi7mqZywiB1bbt4Uoe2Yc+YYxYxWq1+PAg1yz/g
 m1aaox0KZqCxqI32t4HD7dImClbktug79H6ia/EQsHGSGazTd3BNaO7pb/Pwtimq+OFP
 jyR/2voIMwtNuCNLAHav/1Da3gWJce50nOQjUvZf8zCL+9QGDNtHBmUridNFR37s0lCa xw== 
In-Reply-To: <20200211213128.73302-8-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> The tests use both shared and private mapped hugetlb memory, and
> monitors the hugetlb usage counter as well as the hugetlb reservation
> counter. They test different configurations such as hugetlb memory usage
> via hugetlbfs, or MAP_HUGETLB, or shmget/shmat, and with and without
> MAP_POPULATE.
> 
> Also add test for hugetlb reservation reparenting, since this is
> a subtle issue.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org

Thanks for adding the tests.  At a high level, I do not see any issues.

Acked-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
-- 
Mike Kravetz
