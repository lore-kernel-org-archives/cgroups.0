From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/11] memcg: Make it possible to use the stock for more
 than one page.
Date: Mon, 25 Jun 2012 15:33:01 -0700
Message-ID: <CAOS58YNV+uYbGYweSpQNSaRG8ixTG1ugTn42CfuAMO=S2ch6nw@mail.gmail.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-2-git-send-email-glommer@parallels.com>
	<20120625174437.GC3869@google.com>
	<4FE8E632.70602@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=56cTgSX16sEhb3mqi/o6x/zxCYdeAfmIdqnNLspJ1uY=;
        b=gP3In/NMllr0BqpNDkBcnOx71Kf1Rm7EygWoIGrmXjIRyzaGMPQEV9a0fS/KuRsDmA
         jDR33NKt79RgzHITW3FAfeis968MpRJ/MTEUn9cuhkTmyBN83dxfWvLyOqvOvhgc9Vns
         1dUpBpovZvUJE6abbIQ8A2fISkx3u5kul+3auW6RmHWA/3GMEijGUvWZhdl6LkzTXkt3
         LmQhdEp+Ny9LTteEHwdfiL2H0jl5RqYqfgSYd9J52v6RmDL1GyagzDZFz7avsjJM0dXg
         Y52mbCkHPcas2s7lx1qKbpn3rMXJfro82k149sV5+jvRlpV9RipHsJwMY1UWAASjc1y2
         7b8g==
In-Reply-To: <4FE8E632.70602@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Suleiman Souhlal <suleiman@google.com>

Hello,

On Mon, Jun 25, 2012 at 3:29 PM, Glauber Costa <glommer@parallels.com> wrot=
e:
>> It would be nice to explain why this is being done. =A0Just a simple
>> statement like - "prepare for XXX" or "will be needed by XXX".
>
>
> I picked this patch from Suleiman Souhlal, and tried to keep it as close =
as
> possible to his version.
>
> But for the sake of documentation, I can do that, yes.

Yeah, that would be great. Also, the patch does change behavior,
right? Explaining / justifying that a bit would be nice too.

Thanks!

--=20
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
