From: Tim Hockin <thockin@hockin.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom notifications
 to access reserves
Date: Sat, 7 Dec 2013 10:12:19 -0800
Message-ID: <CAAAKZwvanMiz8QZVOU0-SUKYzqcaJAXn0HxYs5+=Zakmnbcfbg@mail.gmail.com>
References: <20131128115458.GK2761@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
	<20131204054533.GZ3556@cmpxchg.org>
	<alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
	<20131205025026.GA26777@htj.dyndns.org>
	<alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
	<20131206173438.GE21724@cmpxchg.org>
	<CAAAKZwsh3erB7PyG6FnvJRgrZhf2hDQCZDx3rMM7NdOdYNCzJw@mail.gmail.com>
	<20131207174039.GH21724@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=e89a8ffbab13126f1904ecf5b400
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=JOVNeiUR1/0wzrytm/7N/0H0kv329WnmCQZvZXMsXvw=;
        b=smfX8jC1dRzJtm1OcPgS1ivhnOC9pPkQaLl2qt8xrB7jHNX0hc2+36j0qGhRj5So6E
         kscKrNgI1covc9QZjllFM/F6WK9+qPDcG6ykTBwBL+dn5aqlOp5FDWy8ckcbaVRDwsBm
         XNjcKt7JYPddUvTBeU00/+vMevujXJGaj1XSdHBGZCfbwlmVAZURn8cYNEs0gMIOT5xA
         rCatdcpEn8+WtBqiZ999Oj9xEZ2Gmssq44+gM9PW1j9os8kV6btHH3nTv0dAPKFCMJYN
         RIJtVV+YZ+GYLDoOx8Ryd0WRRMm/2wK5JOUvjzoyxw6BX1r/dpdfZuLGu8WuC0MBnEjr
         Gwhw==
In-Reply-To: <20131207174039.GH21724@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

--e89a8ffbab13126f1904ecf5b400
Content-Type: text/plain; charset=UTF-8

You more or less described the fundamental change - a score per memcg, with
a recursive OOM killer which evaluates scores between siblings at the same
level.

It gets a bit complicated because we have need if wider scoring ranges than
are provided by default and because we score PIDs against mcgs at a given
scope.  We also have some tiebreaker heuristic (age).

We also have a handful of features that depend on OOM handling like the
aforementioned automatically growing and changing the actual OOM score
depending on usage in relation to various thresholds ( e.g. we sold you X,
and we allow you to go over X but if you do, your likelihood of death in
case of system OOM goes up.

Do you really want us to teach the kernel policies like this?  It would be
way easier to do and test in userspace.

Tim

--e89a8ffbab13126f1904ecf5b400
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">You more or less described the fundamental change - a score =
per memcg, with a recursive OOM killer which evaluates scores between sibli=
ngs at the same level.</p>
<p dir=3D"ltr">It gets a bit complicated because we have need if wider scor=
ing ranges than are provided by default and because we score PIDs against m=
cgs at a given scope.=C2=A0 We also have some tiebreaker heuristic (age).</=
p>

<p dir=3D"ltr">We also have a handful of features that depend on OOM handli=
ng like the aforementioned automatically growing and changing the actual OO=
M score depending on usage in relation to various thresholds ( e.g. we sold=
 you X, and we allow you to go over X but if you do, your likelihood of dea=
th in case of system OOM goes up.</p>

<p dir=3D"ltr">Do you really want us to teach the kernel policies like this=
?=C2=A0 It would be way easier to do and test in userspace.</p>
<p dir=3D"ltr">Tim</p>

--e89a8ffbab13126f1904ecf5b400--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
