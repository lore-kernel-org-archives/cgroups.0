From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v9 0/9] freezer for cgroup v2
Date: Mon, 25 Mar 2019 16:59:53 +0000
Message-ID: <20190325165946.GA30208@tower.DHCP.thefacebook.com>
References: <20190316175812.6787-1-guro@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WCo8XuhCJLkrn0CWeVoXS0xHN9gjFuxpdP/0GdlREII=;
 b=N5ZisgsOjTSehfGAasbav7Icjdyka9OsQ33h2Zw+8HGYTpVmwnz792lgIeEwcZkkkPsx
 TNn2iZIsWCsfcQdfntz/+VZLF3YDnGzdLjrX3POgo6LsxlXx+a/OhFTcJfQn3QgSU21g
 irhWMgVkCxh6OBsYxzwqtyT0gsL1jVkI6cQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCo8XuhCJLkrn0CWeVoXS0xHN9gjFuxpdP/0GdlREII=;
 b=YJZ6QoXhxoyt1i0zmmGcjs8PfHYn6lhVZGeIY7Kz/porEOYr54YOkEsH99WOoUvJZgkFbnitKlAQSu2TLpgj0YFTj6dJefcpAYHjfnUcM9smyVtoJonWTcH2i59RGQxd6Wt4qhw+0BmIepW5ceUaPKrSZqN94QBhSUaVkiDPxec=
In-Reply-To: <20190316175812.6787-1-guro@fb.com>
Content-Language: en-US
Content-ID: <C7171DD08BCF0849BF8181C3DE19B0C8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hello, Oleg!

Can you, please, take a look at the latest version of the patchset?
I'd really appreciate it!

Thank you!

Roman

On Sat, Mar 16, 2019 at 10:58:03AM -0700, Roman Gushchin wrote:
> This patchset implements freezer for cgroup v2.
>=20
> It provides similar functionality as v1 freezer, but the interface
> conforms to the cgroup v2 interface design principles, and it
> provides a better user experience: tasks can be killed, ptrace works,
> there is no separate controller, which has to be enabled, etc.
>=20
> Patches (1), (2) and (3) are some preparational work, patch (4) contains
> the implementation, patch (5) is a small cgroup kselftest fix,
> patch (6) covers freezer adds 6 new kselftests to cover the freezer
> functionality. Patchse (7) and (8) adding tracing points to simplify
> the debugging process. Patch (9) adds corresponding docs.
>=20
> v9->v8:
>   - added support for vfork
>   - added a kselftest test for vfork case
>   - several tests fixes/improvements
>   - renamed stopped* into frozen* across the patchset
>   - added trace points
>   - other minor fixes
