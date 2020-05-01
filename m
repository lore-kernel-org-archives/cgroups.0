From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH net-next 0/2] inet_diag: add cgroup attribute and filter
Date: Fri, 1 May 2020 08:54:08 +0300
Message-ID: <7fb067b2-6c35-6573-82fe-edce194a7e46@yandex-team.ru>
References: <20200430155115.83306-1-zeil@yandex-team.ru>
 <20200430.125506.1341002176317746009.davem@davemloft.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588312450; bh=XMwVjRdapCx1ZzgjFo7tQjSSW8ZXx9fgUKdnncFJSfs=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Vi83saj26yYQO+yf6DyXfGp7sI/ffpMvCROf3BSrOUrxbVNQ1Q1ENJaXbNZ1gMwPL
         c5elxGEp+fN8M4A8xyZowUlD83s1Rg1e4ZebJ2O8tKW92ZoUlxJMeb8zpo9lJNTBd6
         u2eFuoChOoDXZdcUKnxJ5njGWVqbONHMtz2ru5q0=
In-Reply-To: <20200430.125506.1341002176317746009.davem@davemloft.net>
Content-Language: en-CA
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Miller <davem@davemloft.net>, zeil@yandex-team.ru
Cc: netdev@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org

On 30/04/2020 22.55, David Miller wrote:
> From: Dmitry Yakunin <zeil@yandex-team.ru>
> Date: Thu, 30 Apr 2020 18:51:13 +0300
> 
>> This patch series extends inet diag with cgroup v2 ID attribute and
>> filter. Which allows investigate sockets on per cgroup basis. Patch for
>> ss is already sent to iproute2-next mailing list.
> 
> Ok, this looks fine, series applied.
> 
> Although I wish you could have done something like only emit the cgroup
> attribute if it is a non-default value (zero, or whatever it is).
> 
> Every time a new socket attribute is added, it makes long dumps more
> and more expensive.
> 

Maybe then put it under condition

	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
	    ext & (1 << (INET_DIAG_TCLASS - 1))) {

like legacy cgroup id INET_DIAG_CLASS_ID above.

(userspace requests it by INET_DIAG_TCLASS because INET_DIAG_CLASS_ID does not fit into field)
