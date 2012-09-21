From: JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Date: Fri, 21 Sep 2012 18:14:10 +0900
Message-ID: <CAAmzW4MbqMevvxk1ibcogr2ED74kR2_46MRX=VO5dLLa4CZkAA@mail.gmail.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
	<1347977050-29476-7-git-send-email-glommer@parallels.com>
	<CAAmzW4ONnc7n3kZbYnE6n2Cg0ZyPXW0QU2NMr0uRkyTxnGpNqQ@mail.gmail.com>
	<505C2856.70900@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=MD6A0LyI1vLbXq/lD6aMuwc253pXrLunb5P5G4bvIq8=;
        b=HXH8rSZhP/BH98WWSm8m9CANc116VZ0glwHdWSpVn2X7C4T0e515yA7V34bdavBp4+
         G8BczNfTn2Ol2oIxn3xxGYQevx+XcPH+nAjvnasSONJ0qtnBIggugEcn1rUlr/7IW5V4
         01SycQV1+POlzdFMa5tl1Z8FADWYEtA5t2qo2/qkk/A1Tr40zVSNkqJN91EGc+tv03v+
         yH2Kg0bVVAgdgoWzZWVS4g8pI8q3jX2xfByUY7eoclSKyNrPrC2e+kbc/8kiB7S/LUkT
         f8tyeTN/me3kW3e0aw3OpghZg8bBzhdASDp0AYcwRPgBkvU51EWphm/hWrBxzLjtYjaZ
         rN2Q==
In-Reply-To: <505C2856.70900@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

>> "*_memcg = memcg" should be executed when "memcg_charge_kmem" is success.
>> "memcg_charge_kmem" return 0 if success in charging.
>> Therefore, I think this code is wrong.
>> If I am right, it is a serious bug that affect behavior of all the patchset.
>
> Which is precisely what it does. ret is a boolean, that will be true
> when charge succeeded (== 0 test)

Ahh...Okay! I didn't see (== 0 test)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
