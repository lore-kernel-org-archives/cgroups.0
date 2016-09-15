From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: [PATCH v5 0/6] Add eBPF hooks for cgroups
Date: Thu, 15 Sep 2016 08:36:40 +0200
Message-ID: <m3y42tlldz.fsf@neo.luffy.cx>
References: <1473696735-11269-1-git-send-email-daniel@zonque.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=luffy.cx; h=from:to:cc
        :subject:references:date:in-reply-to:message-id:mime-version
        :content-type; s=postfix; bh=B9XeYvUROOwn8cf8rFGTXK1ut9s=; b=um/
        UVhVq2lWf/Zk+7cQ0RMrmhIyk2PEpIko2vcENejn9Xqibhw1ybuAoU2hGgQdxCzp
        /VXwG0UoL++FtoEC8uDjoA5ePfpYspOBPkO5XjaN76T2IRcR3OzcDAc0nuSCqarK
        Mdd4Z9ponrIg83mPM0HgZBT7dtGSqK1mgNW6yio0=
In-Reply-To: <1473696735-11269-1-git-send-email-daniel@zonque.org> (Daniel
        Mack's message of "Mon, 12 Sep 2016 18:12:09 +0200")
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Daniel Mack <daniel@zonque.org>
Cc: htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, pablo@netfilter.org, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

 =E2=9D=A6 12 septembre 2016 18:12 CEST, Daniel Mack <daniel@zonque.org>=C2=
=A0:

> * The sample program learned to support both ingress and egress, and
>   can now optionally make the eBPF program drop packets by making it
>   return 0.

Ability to lock the eBPF program to avoid modification from a later
program or in a subcgroup would be pretty interesting from a security
perspective.
--=20
Use recursive procedures for recursively-defined data structures.
            - The Elements of Programming Style (Kernighan & Plauger)
