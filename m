From: "Alex Ng (LIS)" <alexng@microsoft.com>
Subject: RE: [OOPS] BUG_ON in cgroups on 4.4.0-rc5-next
Date: Tue, 22 Dec 2015 19:06:41 +0000
Message-ID: <BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50@BLUPR0301MB2001.namprd03.prod.outlook.com>
References: <BLUPR0301MB200140C023EB8C2B414F6B13D8E10@BLUPR0301MB2001.namprd03.prod.outlook.com>
 <20151221215618.GB25997@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50BLUPR0301MB2001_"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uuUVKYwH5S572IvQAqcOQnyPu/K6u7VC4Tyc/JBnYXE=;
 b=hlX+MKR9KIYLQtxc+3ufTFNUxOLVgWj9UuZ6YCn5ZH8Tg3c62XyIWDJNm1gsOpXOaoyO6NNC5LACzfD389C6KlMPIV4fFQY74zvqorpwYrv20GhhHVkDDU+NfPsh9txCM1E+2MSDmZYPHQFFc73S145Dd7xPBOUJGAVl3OFRzdI=
In-Reply-To: <20151221215618.GB25997@mtj.duckdns.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: "tj@kernel.org" <tj@kernel.org>
Cc: "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

--_002_BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50BLUPR0301MB2001_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Hello, Alex.
>=20
> On Fri, Dec 18, 2015 at 08:08:03PM +0000, Alex Ng (LIS) wrote:
> > Hi,
> >
> > I was running a "git clone" of the linux-next source tree and hit the
> following BUG_ON condition. My box is running kernel 4.4.0-rc5-next-
> 20151217-52.27. Any ideas on how to pin down the cause?
> >
> > The trace indicates that the following condition in compare_css_sets()
> triggered the oops:
>=20
> Can you please let me know the steps to reproduce the bug?

I tried this on a Hyper-V VM hosted in Windows Server 2012R2 and ran the at=
tached script.=20
The script clones the linux-next tree in a random directory under /tmp in a=
 tight loop.

This panic is not always reproducible, and I have only hit it once after ru=
nning the script about 10 times. A different kernel panic happens each time=
 I run this script; and the panics always happen during the first iteration=
 of the loop.

Let me know if you need more information.

Hope this helps,
Alex

--_002_BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50BLUPR0301MB2001_
Content-Type: application/octet-stream; name="test.sh"
Content-Description: test.sh
Content-Disposition: attachment; filename="test.sh"; size=207;
	creation-date="Tue, 22 Dec 2015 18:52:35 GMT";
	modification-date="Fri, 18 Dec 2015 19:42:25 GMT"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmZ1bmN0aW9uIGNsb25ldHJlZQp7Cgkjd2hpbGUgdHJ1ZTsgZG8KCQljbG9u
ZWRpcj0vdG1wLyQodXVpZGdlbikKCQlnaXQgY2xvbmUgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0LmdpdCAkY2xvbmVkaXIKCQly
bSAtcmYgJGNsb25lZGlyCgkjZG9uZQp9CgpjbG9uZXRyZWUK

--_002_BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50BLUPR0301MB2001_--
