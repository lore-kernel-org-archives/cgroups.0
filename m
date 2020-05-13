From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and
 helper functions
Date: Tue, 12 May 2020 20:03:25 -0600
Message-ID: <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
References: <20200509165202.17959-1-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnascyUsz5V0FDEjsIfa2buK7teLIaGjv2zdFsy2N+M=;
        b=jbH6+xgjghxL7+AaDRjacF4fwhwmz4I9AocgvDMBNPLb/k6T2p2LIk7q6EA1a29kOX
         DF5zI/zYa1GaOeIzUa1Ppxb+RjMle8BzJYls5Bh+w4xvPs2ZrA2vT8f6pvbaHICCg8VH
         p5bHmD7MvdnljHAtr0eVuMGG9JvvAcs4yHQwI5kKzczxqLB20qtZQ6ldHfUJiLghTFma
         NXWF6JBgo/u90RdjqNDMurp3f6uKPcWNKs5WYivrPDuNYpaSJ8w+ltktyc2M+KMymxaQ
         nXxmU9ufx/31W6/oNtLOAADl2+GmsiuNEfIsB1SEBEAUI0TqDrgxU3ep92OVUwc/c2AR
         SRIQ==
In-Reply-To: <20200509165202.17959-1-zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
> This patch prepares infrastructure for matching sockets by cgroups.
> Two helper functions are added for transformation between cgroup v2 ID
> and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
> This cache is needed for faster lookups of socket cgroup.
> 
> v2:
>   - style fixes (David Ahern)
> 

you missed my other comment about this set. Running this new command on
a kernel without support should give the user a better error message
than a string of Invalid arguments:

$ uname -r
5.3.0-51-generic

$ ss -a cgroup /sys/fs/cgroup/unified
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
