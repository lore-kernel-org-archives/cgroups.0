From: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup attach task - slogging cpu
Date: Fri, 4 Oct 2013 10:55:56 +0530
Message-ID: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c22634726fab04e7e38928
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=SGmNDSE4qZ61Bq5Sq3dHyx/qA+mK0GB/tB89CnmVlBQ=;
        b=di8GAQUZqKi7tOWf0sdryLN9BP84r2IboNdi9NBQji7HCevKuWyXfuLNVXTiecej6j
         UxYUEm41Z+kGXGZQ9vlerhDTz68eoL0hPnl6eJTvGTtOae4l+V07q+PhkHjR9FojfPsi
         xpuqChGkne2CHumV6ALD63qNj1bTxIM1o88YdTNabDln2BVtCZwI0NjkmZELZ59aqNjE
         pNoxGfPYf7aTOPDeCBr9H7m80mvRxDHtBkjNsZLYBVlYiRMmuyNOYXfUZIb+tEzqCFTf
         yb9kfVtL2gaUzpsokCE+DhuLPYpaNFwEMHPHQ5goZYqvj+pdBIPExmtB+nucsNn1NDsb
         PZFg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--001a11c22634726fab04e7e38928
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Oleg, All

I saw an issue of CPU slogging posted in
https://lkml.org/lkml/2013/8/28/283, and require your valuable
suggestion on a very similar issue I am facing.

We are facing the issue of cpu slogging in the function
    cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
bool threadgroup)
in the do-while loop which iterates over the threadgroup.

 rcu_read_lock();
 do {
 struct task_and_cgroup ent;

 /* @tsk either already exited or can't exit until the end */
 if (tsk->flags & PF_EXITING)
 continue;

 /* as per above, nr_threads may decrease, but not increase. */
 BUG_ON(i >=3D group_size);
 ent.task =3D tsk;
 ent.cgrp =3D task_cgroup_from_root(tsk, root);
 /* nothing to do if this task is already in the cgroup */
 if (ent.cgrp =3D=3D cgrp)
 continue;
 /*
 * saying GFP_ATOMIC has no effect here because we did prealloc
 * earlier, but it's good form to communicate our expectations.
 */
 retval =3D flex_array_put(group, i, &ent, GFP_ATOMIC);
 BUG_ON(retval !=3D 0);
 i++;

 if (!threadgroup)
 break;
 } while_each_thread(leader, tsk);

Problem Observed:
In this loop, in case of a single thread, and argument =93bool
threadgroup=94 as =93false=94 and
if(ent.cgrp =3D=3D cgrp) is true
we will continue to the next thread instead of breaking out of the loop.

Possible Solution and Doubt:
When a break condition was added as shown in the patch attached, the
cpu sluggishness was not occurring.
Can you please provide your suggestions, if this is the right way to
fix the above mentioned issue.
Also, if a fix is already in for this, can you please guide me to that.

Thanks and Regards
Anjana

--001a11c22634726fab04e7e38928
Content-Type: application/octet-stream; 
	name="cgroup_singe_thread_attach.patch"
Content-Disposition: attachment; filename="cgroup_singe_thread_attach.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmcwz5eg0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAuYyBiL2tlcm5lbC9jZ3JvdXAuYwppbmRleCAxZjUz
Mzg3Li5jYWU4NDE2IDEwMDY0NAotLS0gYS9rZXJuZWwvY2dyb3VwLmMKKysrIGIva2VybmVsL2Nn
cm91cC5jCkBAIC0yMDAyLDcgKzIwMDIsOSBAQCBzdGF0aWMgaW50IGNncm91cF9hdHRhY2hfdGFz
ayhzdHJ1Y3QgY2dyb3VwICpjZ3JwLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaywKIAkJZW50LnRh
c2sgPSB0c2s7CiAJCWVudC5jZ3JwID0gdGFza19jZ3JvdXBfZnJvbV9yb290KHRzaywgcm9vdCk7
CiAJCS8qIG5vdGhpbmcgdG8gZG8gaWYgdGhpcyB0YXNrIGlzIGFscmVhZHkgaW4gdGhlIGNncm91
cCAqLwotCQlpZiAoZW50LmNncnAgPT0gY2dycCkKKwkJaWYgKGVudC5jZ3JwID09IGNncnAgJiYg
IXRocmVhZGdyb3VwKQorCQkJYnJlYWs7CisJCWVsc2UgaWYoZW50LmNncnAgPT0gY2dycCkKIAkJ
CWNvbnRpbnVlOwogCQkvKgogCQkgKiBzYXlpbmcgR0ZQX0FUT01JQyBoYXMgbm8gZWZmZWN0IGhl
cmUgYmVjYXVzZSB3ZSBkaWQgcHJlYWxsb2MKQEAgLTIxOTksNyArMjIwMSw2IEBAIHJldHJ5X2Zp
bmRfdGFzazoKIAlyZXQgPSBjZ3JvdXBfYXR0YWNoX3Rhc2soY2dycCwgdHNrLCB0aHJlYWRncm91
cCk7CiAKIAl0aHJlYWRncm91cF91bmxvY2sodHNrKTsKLQogCXB1dF90YXNrX3N0cnVjdCh0c2sp
Owogb3V0X3VubG9ja19jZ3JvdXA6CiAJbXV0ZXhfdW5sb2NrKCZjZ3JvdXBfbXV0ZXgpOwo=
--001a11c22634726fab04e7e38928--
