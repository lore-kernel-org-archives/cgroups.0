From: Tim Hockin <thockin@google.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
Date: Thu, 13 Mar 2014 11:05:15 -0700
Message-ID: <CAO_RewYiZVpbu8axKY+FtkaarjA_DohD2e==jcvdWn68ubcR+w@mail.gmail.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com> <5320CAEC.6030008@amacapital.net>
 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
 <1394658983.32465.203.camel@willson.li.ssimo.org> <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org> <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
 <1394675038.32465.223.camel@willson.li.ssimo.org> <CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
 <1394733077.32465.243.camel@willson.li.ssimo.org> <CALCETrXWzja6W6y=p9MrtynGZMsrD5KQu0KBK6Bs1dQxnesv2A@mail.gmail.com>
 <1394733526.32465.250.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=MEd2qBpLzzyG/URbrV56U8t1Am00Se3Wt3T03Yoz9SM=;
        b=aCjb8A5m+hetFzRSPpIzcllFygIqzyeGqVgS5GLBORyqTl8FY+9L/BFeFYnCFxUljj
         cpoCBw0r4f51tixnGurY1EzpWazn1yGlbgUCocKC3mNNhXfQYVv4lH3wZGlDidClxw+/
         EAqdnAl12A5S5nqrGBJ1IOiXWZBuKePkAMmDnMDMN8cXqWQcO3SwC6E4XOPSArys5R6H
         hwQKfFSgdbm3/fOszsPJ864qsLX2C7/c+NFKltnMCVR0h2r0mDGQbxmU9yJ0IhVXWIDl
         VMHNU1LRmqyoLxtFk8fJNOZidGjU/KIAWP3F2PXIFf8fsSMOe9bFE37PFWC3lHZ8eD4A
         Vndw==
In-Reply-To: <1394733526.32465.250.camel@willson.li.ssimo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Simo Sorce <ssorce@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Vivek Goyal <vgoyal@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>, jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com

I don't buy that it is not practical.  Not convenient, maybe.  Not
clean, sure.  But it is practical - it uses mechanisms that exist on
all kernels today.  That is a win, to me.

On Thu, Mar 13, 2014 at 10:58 AM, Simo Sorce <ssorce@redhat.com> wrote:
> On Thu, 2014-03-13 at 10:55 -0700, Andy Lutomirski wrote:
>>
>> So give each container its own unix socket.  Problem solved, no?
>
> Not really practical if you have hundreds of containers.
>
> Simo.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
