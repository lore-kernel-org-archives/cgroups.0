From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 07:36:17 -0700
Message-ID: <0F2FA70F-8C7E-4D7D-B685-244A76BDB459@amacapital.net>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <87d0uqpba5.fsf@xmission.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Od3N1wcXJvUpd0PxTTwy6ZnytWciK1KR8OXq83jCjNw=;
        b=cWGPdesvVHmNUSRMPGrJd49EcCmb3Y/WsXAKLQ8qrVL228cU2SkpHBws+jZT5tu/69
         PDs5kTBPAVEeq6r7p0kBGhINDnOF/qd5IHE4LOhlSHluWBIx8bIWOIE2CtX7bw3DBCJ0
         LD3kppSQzFQeqz58R/tYRKQjIkYGUTjZBMcOS8yW7cG9NIMK7m76EJlK1mpCtQwe9xV4
         YL3YPBEClvCJsgUrFWCZxhHzUWXpjlLw2d4UZcj0A+ZnpGBOZ7o8Z6s+nM2zaggN79XM
         VJTUqR2Udsaw6ZzDlaqdigMeaETUEtEUWAap4EHUnPOqUBc5OpNMSqpV4/jL5oVorcPP
         EbJQ==
In-Reply-To: <87d0uqpba5.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>



> On Aug 10, 2018, at 7:05 AM, Eric W. Biederman <ebiederm@xmission.com> wro=
te:
>=20
>=20
> There is a serious problem with mount options today that fsopen does not
> address.  The problem is that mount options are ignored for block based
> filesystems, and any other type of filesystem that follows the same
> pattern.
>=20

> /dev/loop0 /root/loop0-noacl-noquota-nouser_xattr ext4 rw,relatime,nouser_=
xattr,noacl 0 0
> /dev/loop0 /root/loop0-acl-quota-user_xattr ext4 rw,relatime,nouser_xattr,=
noacl 0 0

To make sure I understand correctly: the problem is that the second mount ig=
nored the options because the device was already mounted, right?

For the new API, I think the only remotely sane approach is to refuse to mou=
nt or init or whatever you call it an already mounted bdev. If user code gen=
uinely needs to bind-mount an existing mount that is known only by its bdev,=
 we can add a specific API just for that.=
