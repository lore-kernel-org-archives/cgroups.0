From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Wed, 18 Apr 2018 17:41:29 -0700
Message-ID: <32d3e7a6-36f0-571a-bb91-67f746c7eafa@schaufler-ca.com>
References: <cover.1521179281.git.rgb@redhat.com>
 <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
 <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1524098500; bh=IkTC3qdnwxIFqch5yLRe8frKfvV4jXfufWZ3gU6h44k=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=gG3XT5QRvEqRJErFfFpHu4fN7bWdLWDk67onweW58AJoYS+9+BvZDtaiDfxXwPFqZxKbhG7U8ZvSHBUB5ycHJnDdmqXr6xDOKko/G8TUTaHP5ka0KxUuFwJ+npLFLye2E2kglqdd7sH4i2YsNwB4IR7HJpTd52SBO1ivHnS0lBDoNZ1yM5CQ5oXGhVsbBEQb4o3a961rlSsd9WCkjfnUiMlTnQKSzHTw96OlsmStG3HZqrJkxsVmQAItlQlfuI7dUPXF20zKWKRpsm57IipwZBuNy5fzpjgSRUJwmU0PSbc1WnmdVtoCrmaLWhoHnXNat9CYMmfSgv2PhF5bVjdHOA==
In-Reply-To: <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Moore <paul@paul-moore.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com

On 4/18/2018 4:47 PM, Paul Moore wrote:
> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> Implement the proc fs write to set the audit container ID of a process,
>> emitting an AUDIT_CONTAINER record to document the event.
>> ...
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d258826..1b82191 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -796,6 +796,7 @@ struct task_struct {
>>  #ifdef CONFIG_AUDITSYSCALL
>>         kuid_t                          loginuid;
>>         unsigned int                    sessionid;
>> +       u64                             containerid;
> This one line addition to the task_struct scares me the most of
> anything in this patchset.  Why?  It's a field named "containerid" in
> a perhaps one of the most widely used core kernel structures; the
> possibilities for abuse are endless, and it's foolish to think we
> would ever be able to adequately police this.

If we can get the LSM infrastructure managed task blobs from 
module stacking in ahead of this we could create a trivial security
module to manage this. It's not as if there aren't all sorts of
interactions between security modules and the audit system already.


