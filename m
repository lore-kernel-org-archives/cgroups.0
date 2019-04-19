From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 19 Apr 2019 16:36:25 +0000
Message-ID: <20190419163621.GB23357@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190419151912.GA12152@redhat.com>
 <20190419160806.GA12790@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tXZXTuwJqmvt1Osg9KUTD91OtdRWmwNNeUxLicW6EG0=;
 b=Np96Wt8z/X+t0sDqG3WbeHzOTyoQoEdGrO35IeLCHdzUDr3djQkTWwgEbAEltdVbNOW+
 cjiZyAnPHBI4bC5pXssu/0u/jVgKB7d57cYBAEgBlrA0WIWqvUJ8dbJ0qcWsvIGyyvO8
 NOqrgwRnaMmYi4VlhF64R8KzrZVB/SjH/ok= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXZXTuwJqmvt1Osg9KUTD91OtdRWmwNNeUxLicW6EG0=;
 b=dGrwTUEAWZg5kW9d3K7VGj9BqBm1ft5axjvxAeeSSjk0WKjBjKKlzfucc2vqfQxE7S+7qbw4WNO1RVtixqaFNzUdHwxm6qkNUUgdjlmN4lPTQgttKO2GiVIH3FgShH0HEyQzAWA6Bs344/dui6wekdrk2C4WOAEwuZVJ6wcUgk8=
In-Reply-To: <20190419160806.GA12790@redhat.com>
Content-Language: en-US
Content-ID: <5F46C0AB64172A469D33882B0DB73797@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Apr 19, 2019 at 06:08:06PM +0200, Oleg Nesterov wrote:
> Anyway, I do not want to delay this feature. Even if I am right we can
> cleanup this code later. I see nothing really wrong, so no objections
> from me. Sorry for delay.

This is great!

Thank you so much for your time spent reviewing all these iterations!
I hope the patchset is in a much better state now.

Roman
