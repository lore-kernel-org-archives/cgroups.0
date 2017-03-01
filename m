From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to
	refcount_t
Date: Wed, 1 Mar 2017 14:35:15 -0500
Message-ID: <CAHC9VhR8FO+YDFy+jfL_Bv5SYHR1vjkznmber1xV+mWridg5fw@mail.gmail.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
	<1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
	<CAHC9VhQW7xFHBLNQOQRKMftStu_aHjbUmp96VJrcfWzxuzE_kw@mail.gmail.com>
	<2236FBA76BA1254E88B949DDB74E612B41C4DE27@IRSMSX102.ger.corp.intel.com>
	<CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A@mail.gmail.com>
	<CAGXu5j+FdV--H8VBxJoZnY6ktgiyv4xSheQOkD77B-L-Cd1SVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:from:date:message-id:subject:to
	:cc; bh=v/CZOH9it/u9PpYmRhF1pBUOoJNnskuxBGL7JMtLBfw=;
	b=SdBvO9Ax5LZ0gB2lLlsDi/n+UkeWWrlHk47DeQ4xtBJGLX4Ly0Pi2i4DmZUYXLOPqP
	x7cXsoNcBjZPLeD5lLDEhIG72KuVTh8expcjQmfORHao9D52pK8pIkJn7XSAIt8xMJZH
	CjLifNUW4PedR2uaCX+AJhLugRnB1oRAbLjStibL2zjMUV7Npt57eNQtfqif0aKla7yk
	SOQ7ZJiTN7eeFCLuWkRulAoc/+PYB237Pj5pd5Fgv6SnuroU4zremo9QXtLbdzgndvoh
	g9z6A0nkv+hDzOQRVlEaFGJDkArx/1nZl3+RezSgNYXgQlWnRXyBf09D5ZkPhLSepiE4
	PK/Q==
In-Reply-To: <CAGXu5j+FdV--H8VBxJoZnY6ktgiyv4xSheQOkD77B-L-Cd1SVg@mail.gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: "lizefan@huawei.com" <lizefan@huawei.com>, "arnd@arndb.de" <arnd@arndb.de>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "acme@kernel.org" <acme@kernel.org>, "tj@kernel.org" <tj@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "luto@kernel.org" <luto@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

On Tue, Feb 28, 2017 at 7:16 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Feb 28, 2017 at 2:11 PM, Paul Moore <paul@paul-moore.com> wrote:
>> I just realized that include/linux/refcount.h didn't make it into
>> v4.10 which means there is going to be delay until I merge them into
>> the audit tree (I don't base the tree on -rc releases except under
>> extreme circumstances).  I've got the patches queued up in a private
>> holding branch (I added #includes BTW) so I won't forget, but as a
>> FYI, they likely won't make it in until v4.12.
>
> I'm not asking for you to change this, but I am curious: doesn't that
> force you to always be a release behind? I've tended to base trees on
> -rc2 (and then the final release while the next merge window is open).
> But that may be because I tend to have such wide dependencies...

In general, yes ... and if you are just looking for the short answer
I'd leave it at that.  I do leave door open for exceptions under
unusual circumstances, but I don't believe the refcount_t conversion
is one of those cases.

The longer answer lies in a balancing act between what I understand
Linus' and/or James desires (different upstream maintainers, different
approaches, but for my own sanity I like to stick to a single
"process" across my trees), the linux-next effort, branch stability
(aka limited or predictable rebases), and my own testing requirements.
First off, the current policy I follow for the SELinux and audit trees
can be found here:

* http://www.paul-moore.com/blog/d/2016/03/kernel-repo-process.html

... it's relatively simple and has proven to work reasonably well over
the past year or so.  On occasion, the subsystem changes in a given
release are significant enough that I skip a rebase (step #2 in the
process) but that has only happened once (twice?) with the audit tree
and didn't prove to be a real problem; this is less of an issue with
the SELinux tree as James often rebases the linux-security tree to the
current -rc1 or -rc2 tree.

As for the balancing act ... My understanding is that Linus doesn't
like to see pull requests from trees based on -rcX tags, he would much
prefer to see trees based on a proper release, e.g. v4.10; on the plus
side, Linus is willing to put up with some merge fuzzing so long as it
is understandable and/or well explained.  James wants pull requests
that apply with zero merge conflicts to his linux-security/next tree;
on the plus side, the linux-security/next tree tends to be based on
the current -rc1/2 so a broad set of dependencies isn't too bad (which
is important for SELinux).  The linux-next people want to see a commit
ID follow a steady progression of multiple weeks in the subsystem
-next branch and then a trickle up through various trees until it hits
Linus' tree.  The branch stability requirements are pretty obvious,
and with the exception of the -next branches during/immediately-after
the merge window, I don't really rebase branches unless there is a
Very Good Reason.  Finally, my own testing requirements are such that
I want to test the current SELinux and audit -next/-stable branches
against the latest bits in Linus' tree (e.g. -rcX releases) on a
weekly basis so keeping those branches as current as possible is
important; I talked a bit more about my testing at Flock 2016,
slides/video at the link below:

* http://www.paul-moore.com/blog/d/2016/08/flock-kernel-testing.html
* https://copr.fedorainfracloud.org/coprs/pcmoore/kernel-secnext

There ya go, probably more than you wanted to know, but that's why
things are the way they are with the SELinux and audit trees.  I
remain open to new ideas about how to manage the trees, but the
current arrangement seems to work reasonably well at the moment.

-- 
paul moore
www.paul-moore.com
