From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 2/2] ss: add support for cgroup v2
 information and filtering
Date: Tue, 5 May 2020 09:50:04 -0600
Message-ID: <72f12b35-0dd2-81b2-aeb1-52822c7fe03a@gmail.com>
References: <20200430155245.83364-1-zeil@yandex-team.ru>
 <20200430155245.83364-3-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yJr8RqITkDOSGCYSWIKgpqgvoSgqR2F95IvJn3b0ji4=;
        b=jc0CkDP2R64dQQyGSslB9qk/kYm/zxhSNRdlUNAK+ACzkAtWZbgvmHATjia5aFel8o
         ElMXA5x7gAZLp3+uLkYOhyRcrFWJzBB/UbPMP13/+JUlYldi3ceOhNrLPAIajFuWghfe
         4abpBFl5979n9mX1uHFxWoL3nV6mUZe8yOGN+Bl8VdaKGIiqUGLfZujSE7nvS5iT3xK+
         V0jzCJNs2wlkSo9P7QPvg/3iAR3omJKATAltVkVslcBb+lVAdSBiXwGwpJFPfRMQb+c8
         alpJv9gVvRJeXd7dOw9ON+bWn+LD7wulFhfsvjoZHRydZtGMgT+f6giTXOtbUq8aipyo
         EjYg==
In-Reply-To: <20200430155245.83364-3-zeil@yandex-team.ru>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, cgroups@vger.kernel.org, bpf@vger.kernel.org

On 4/30/20 9:52 AM, Dmitry Yakunin wrote:
> This patch introduces two new features: obtaining cgroup information and
> filtering sockets by cgroups. These features work based on cgroup v2 ID
> field in the socket (kernel should be compiled with CONFIG_SOCK_CGROUP_DATA).
> 
> Cgroup information can be obtained by specifying --cgroup flag and now contains
> only pathname. For faster pathname lookups cgroup cache is implemented. This
> cache is filled on ss startup and missed entries are resolved and saved
> on the fly.
> 
> Cgroup filter extends EXPRESSION and allows to specify cgroup pathname
> (relative or absolute) to obtain sockets attached only to this cgroup.
> Filter syntax: ss [ cgroup PATHNAME ]
> Examples:
>     ss -a cgroup /sys/fs/cgroup/unified (or ss -a cgroup .)
>     ss -a cgroup /sys/fs/cgroup/unified/cgroup1 (or ss -a cgroup cgroup1)
> 

on a kernel without support for this feature:

$ misc/ss -a cgroup /sys/fs/cgroup/unified
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
Netid    State    Recv-Q    Send-Q       Local Address:Port         Peer
Address:Port    Process

New iproute2 can be run on older kernels, so errors should be cleanly
handled.
