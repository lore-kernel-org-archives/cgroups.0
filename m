From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] net: fix sleeping while atomic problem in sock
 mem_cgroup.
Date: Fri, 16 Dec 2011 11:10:09 +0100
Message-ID: <1324030209.2273.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324026582-5214-1-git-send-email-glommer@parallels.com>
	  <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <4EEB1508.3080405@parallels.com>
	 <1324029886.2273.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EEB1807.1000308@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=zGz7IH7Fm05nTd34zv3tyzWF3bsasKKXZuj22gl2LEg=;
        b=nZ1EjoTj1/eZwML2Ibo8H36WnhNi8FUD0VDSNCco371sSBgZgGlT/hC0XZKpFm3mO1
         fSzkjF9CkpwfokHFd5txmcsCJ1ukuOP6yC7FYJGDRWcuFkloXeYN0Nf5rc8s6DcHa8Zt
         M/D6dM4wEPhLprLNlpRxK5c4oK3tq/fRcu0WU=
In-Reply-To: <4EEB1807.1000308@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org, cgroups@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Randy Dunlap <rdunlap@xenotime.net>

Le vendredi 16 d=C3=A9cembre 2011 =C3=A0 14:05 +0400, Glauber Costa a =C3=
=A9crit :

> Well, in this case, I myself think this is a better solution. Do you=20
> want to push the patch yourself, or should I do it ?
>=20

Please do it, I'll add my SOB after yours, thanks !


